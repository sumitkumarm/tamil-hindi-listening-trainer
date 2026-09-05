import SwiftUI

struct SpeakView: View {
    @EnvironmentObject private var model: AppModel
    @EnvironmentObject private var speech: HindiSpeechService
    @EnvironmentObject private var checker: SpeechCheckerService
    @State private var countedThisTry = false

    private var target: String {
        model.currentDay.roleplay.bestChoice
    }

    var body: some View {
        ZStack {
            PesaBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    SpeakHeader(day: model.currentDay)
                    TargetCard(day: model.currentDay, target: target)
                    RecordingCard(target: target, countedThisTry: $countedThisTry)
                    SpeakingPrinciples()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 18)
            }
        }
        .navigationTitle("Speak it")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            countedThisTry = false
        }
        .onDisappear {
            checker.stop()
            speech.stop()
        }
    }
}

private struct SpeakHeader: View {
    let day: CourseDay

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            EyebrowText(text: "Speaking lab")
            Text("Say one useful line")
                .font(.system(size: 31, weight: .black, design: .rounded))
                .foregroundStyle(PesaColors.ink)
            Text("Day \(day.number) · \(day.roleplay.title)")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(PesaColors.moss)
            Text("Use the Hindi voice to listen, then try the same idea in your own voice.")
                .font(.subheadline)
                .foregroundStyle(PesaColors.slate)
        }
    }
}

private struct TargetCard: View {
    @EnvironmentObject private var speech: HindiSpeechService

    let day: CourseDay
    let target: String

    var body: some View {
        CardSurface {
            VStack(alignment: .leading, spacing: 13) {
                HStack {
                    Label("Your target", systemImage: "target")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(PesaColors.coral)
                    Spacer()
                    Text("Day \(day.number)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(PesaColors.slate)
                }
                Text(target)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(PesaColors.ink)
                    .fixedSize(horizontal: false, vertical: true)
                Text(day.roleplay.helpfulReplyTamil)
                    .font(.subheadline)
                    .foregroundStyle(PesaColors.slate)
                Text(day.roleplay.helpfulReplyEnglish)
                    .font(.caption)
                    .italic()
                    .foregroundStyle(PesaColors.slate)
                AudioButton(title: "Hear target", phrase: target, speechText: day.roleplay.bestChoiceSpeechText)
                if !speech.statusMessage.isEmpty {
                    Text(speech.statusMessage)
                        .font(.caption)
                        .foregroundStyle(PesaColors.coral)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
}

private struct RecordingCard: View {
    @EnvironmentObject private var model: AppModel
    @EnvironmentObject private var checker: SpeechCheckerService

    let target: String
    @Binding var countedThisTry: Bool

    var body: some View {
        CardSurface {
            VStack(alignment: .leading, spacing: 13) {
                HStack {
                    Label("Rough speaking check", systemImage: "waveform")
                        .font(.headline)
                        .foregroundStyle(PesaColors.ink)
                    Spacer()
                    if checker.state == .recording {
                        Circle()
                            .fill(PesaColors.coral)
                            .frame(width: 10, height: 10)
                            .accessibilityLabel("Recording")
                    }
                }
                Text(checker.message)
                    .font(.subheadline)
                    .foregroundStyle(PesaColors.slate)
                    .fixedSize(horizontal: false, vertical: true)
                Button(action: toggleRecording) {
                    Label(checker.state == .recording ? "Stop recording" : "Record my attempt", systemImage: checker.state == .recording ? "stop.fill" : "mic.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.borderedProminent)
                .tint(checker.state == .recording ? PesaColors.coral : PesaColors.moss)
                if !checker.transcript.isEmpty {
                    TranscriptResult(target: target, transcript: checker.transcript)
                    if checker.state == .finished && !countedThisTry {
                        Button("Count this as a speaking practice") {
                            model.recordSpeakingCheck()
                            countedThisTry = true
                        }
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(PesaColors.coral)
                    } else if countedThisTry {
                        Label("Practice counted", systemImage: "checkmark.circle.fill")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(PesaColors.moss)
                    }
                }
                Text("This compares transcript word overlap only. It does not grade accent, grammar, or fluency.")
                    .font(.caption2)
                    .foregroundStyle(PesaColors.slate)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private func toggleRecording() {
        if checker.state == .recording {
            checker.stop()
        } else {
            countedThisTry = false
            checker.requestAndStart()
        }
    }
}

private struct TranscriptResult: View {
    let target: String
    let transcript: String

    private var overlap: Int {
        let targetWords = words(target)
        let transcriptWords = Set(words(transcript))
        guard !targetWords.isEmpty else { return 0 }
        let matches = targetWords.filter { transcriptWords.contains($0) }.count
        return Int((Double(matches) / Double(targetWords.count) * 100).rounded())
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Text("ROUGH OVERLAP")
                    .font(.caption2.weight(.bold))
                    .tracking(0.9)
                    .foregroundStyle(PesaColors.coral)
                Spacer()
                Text("\(overlap)%")
                    .font(.title3.weight(.black))
                    .foregroundStyle(PesaColors.moss)
            }
            Text(transcript)
                .font(.body.weight(.semibold))
                .foregroundStyle(PesaColors.ink)
                .fixedSize(horizontal: false, vertical: true)
            Text("Recognized words can be a useful prompt to repeat once more.")
                .font(.caption)
                .foregroundStyle(PesaColors.slate)
        }
        .padding(13)
        .background(PesaColors.mossLight.opacity(0.6), in: RoundedRectangle(cornerRadius: 15, style: .continuous))
    }

    private func words(_ value: String) -> [String] {
        value.lowercased()
            .split(whereSeparator: { !$0.isLetter && !$0.isNumber })
            .map(String.init)
    }
}

private struct SpeakingPrinciples: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            Label("Keep the target small", systemImage: "lightbulb.fill")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(PesaColors.ink)
            Text("A rough first attempt is a win. Listen again, copy the rhythm, and try once more when you have energy. The course measures practice, not a promise of fluent speech.")
                .font(.caption)
                .foregroundStyle(PesaColors.slate)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, 4)
    }
}
