import AVFoundation
import Combine
import Foundation
import Speech
import UIKit

@MainActor
final class HindiSpeechService: NSObject, ObservableObject, AVAudioPlayerDelegate, AVSpeechSynthesizerDelegate {
    @Published private(set) var isSpeaking = false
    @Published private(set) var statusMessage = ""

    private let synthesizer = AVSpeechSynthesizer()
    private var audioPlayer: AVAudioPlayer?

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func speak(_ phrase: String, speechText: String? = nil, resourceName: String? = nil, slow: Bool = false) {
        stop()
        configureAudioSession()

        if let resourceName,
           let url = Bundle.main.url(forResource: resourceName, withExtension: "mp3", subdirectory: "Audio")
            ?? Bundle.main.url(forResource: resourceName, withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.delegate = self
                audioPlayer?.prepareToPlay()
                audioPlayer?.rate = slow ? 0.78 : 1.0
                audioPlayer?.enableRate = true
                isSpeaking = audioPlayer?.play() == true
                statusMessage = ""
                return
            } catch {
                statusMessage = "The saved Hindi clip could not be played."
            }
        }

        guard let voice = AVSpeechSynthesisVoice(language: "hi-IN") else {
            statusMessage = "Add a Hindi voice in Settings, or use the saved clips in the first lessons."
            return
        }

        let utterance = AVSpeechUtterance(string: speechText ?? phrase)
        utterance.voice = voice
        utterance.rate = slow ? 0.34 : 0.48
        utterance.pitchMultiplier = 1.0
        utterance.volume = 1.0
        isSpeaking = true
        statusMessage = ""
        synthesizer.speak(utterance)
    }

    func stop() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        audioPlayer?.stop()
        try? AVAudioSession.sharedInstance().setActive(false, options: [.notifyOthersOnDeactivation])
        isSpeaking = false
    }

    private func configureAudioSession() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
        try? session.setActive(true, options: [])
    }

    nonisolated func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        Task { @MainActor [weak self] in
            self?.isSpeaking = false
        }
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        Task { @MainActor [weak self] in
            self?.isSpeaking = false
        }
    }
}

@MainActor
final class SpeechCheckerService: NSObject, ObservableObject, SFSpeechRecognizerDelegate {
    enum State: Equatable {
        case idle
        case requestingPermission
        case recording
        case finished
        case unavailable
    }

    @Published private(set) var state: State = .idle
    @Published private(set) var transcript = ""
    @Published private(set) var message = "Tap record, say the target, and stop when you finish."

    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "hi-IN"))
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var sessionToken = 0
    private var lifecycleObservers: [NSObjectProtocol] = []

    override init() {
        super.init()
        recognizer?.delegate = self
        let center = NotificationCenter.default
        lifecycleObservers = [
            center.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: .main) { [weak self] _ in
                Task { @MainActor [weak self] in
                    self?.stopForLifecycleChange()
                }
            },
            center.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { [weak self] _ in
                Task { @MainActor [weak self] in
                    self?.stopForLifecycleChange()
                }
            }
        ]
    }

    deinit {
        lifecycleObservers.forEach(NotificationCenter.default.removeObserver)
    }

    func requestAndStart() {
        guard let recognizer else {
            state = .unavailable
            message = "Hindi speech recognition is unavailable on this device."
            return
        }

        invalidateRecordingWork()
        sessionToken += 1
        let token = sessionToken
        state = .requestingPermission
        SFSpeechRecognizer.requestAuthorization { [weak self] authorization in
            Task { @MainActor [weak self] in
                guard let self else { return }
                guard self.sessionToken == token, self.state == .requestingPermission else { return }
                guard authorization == .authorized else {
                    self.state = .unavailable
                    self.message = "Speech permission is off. You can still practise by listening and repeating."
                    return
                }
                AVAudioSession.sharedInstance().requestRecordPermission { granted in
                    Task { @MainActor [weak self] in
                        guard let self else { return }
                        guard self.sessionToken == token, self.state == .requestingPermission else { return }
                        guard granted else {
                            self.state = .unavailable
                            self.message = "Microphone permission is off. Enable it in Settings to try speaking."
                            return
                        }
                        self.beginRecording(using: recognizer, token: token)
                    }
                }
            }
        }
    }

    func stop() {
        let wasActive = state == .recording || state == .requestingPermission
        sessionToken += 1
        invalidateRecordingWork()
        guard wasActive else { return }
        state = .finished
        message = transcript.isEmpty ? "No words came through. Try one short line." : "Here is the rough transcript. It is a practice hint, not a pronunciation grade."
    }

    func stopForLifecycleChange() {
        guard state == .recording || state == .requestingPermission else { return }
        sessionToken += 1
        invalidateRecordingWork()
        state = .idle
        message = "Recording stopped when the app left the foreground."
    }

    private func invalidateRecordingWork() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest = nil
        try? AVAudioSession.sharedInstance().setActive(false, options: [.notifyOthersOnDeactivation])
    }

    func clear() {
        stop()
        transcript = ""
        state = .idle
        message = "Tap record, say the target, and stop when you finish."
    }

    private func beginRecording(using recognizer: SFSpeechRecognizer, token: Int) {
        guard sessionToken == token, state == .requestingPermission else { return }
        guard recognizer.isAvailable else {
            state = .unavailable
            message = "Hindi recognition is temporarily unavailable. Check your connection and try again."
            return
        }

        recognitionTask?.cancel()
        recognitionTask = nil
        transcript = ""

        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.record, mode: .measurement, options: [.duckOthers])
        try? session.setActive(true, options: .notifyOthersOnDeactivation)

        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        request.taskHint = .dictation
        recognitionRequest = request

        let inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: 0)
        inputNode.removeTap(onBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1_024, format: format) { buffer, _ in
            request.append(buffer)
        }

        audioEngine.prepare()
        do {
            try audioEngine.start()
            state = .recording
            message = "Listening… say the line in a natural voice."
        } catch {
            inputNode.removeTap(onBus: 0)
            request.endAudio()
            recognitionRequest = nil
            try? AVAudioSession.sharedInstance().setActive(false, options: [.notifyOthersOnDeactivation])
            state = .unavailable
            message = "The microphone could not start. Try again or continue with listen-and-repeat."
            return
        }

        recognitionTask = recognizer.recognitionTask(with: request) { [weak self] result, error in
            Task { @MainActor [weak self] in
                guard let self else { return }
                guard self.sessionToken == token, self.state == .recording else { return }
                if let result {
                    self.transcript = result.bestTranscription.formattedString
                    if result.isFinal {
                        self.finishRecording()
                    }
                }
                if error != nil, self.sessionToken == token, self.state == .recording {
                    self.finishRecording()
                }
            }
        }
    }

    private func finishRecording() {
        guard state == .recording else { return }
        sessionToken += 1
        invalidateRecordingWork()
        state = .finished
        message = transcript.isEmpty ? "No words came through. Try one short line." : "Here is the rough transcript. It is a practice hint, not a pronunciation grade."
    }

    nonisolated func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        Task { @MainActor [weak self] in
            guard let self, !available else { return }
            self.state = .unavailable
            self.message = "Hindi recognition is unavailable right now."
        }
    }
}
