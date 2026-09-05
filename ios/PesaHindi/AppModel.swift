import Combine
import Foundation

@MainActor
final class AppModel: ObservableObject {
    @Published private(set) var progress: LearningProgress
    @Published private(set) var isOnboarded: Bool

    let speechService: HindiSpeechService
    let speechChecker: SpeechCheckerService

    private let defaults: UserDefaults
    private let progressKey = "pesa-hindi.learning-progress"
    private let onboardedKey = "pesa-hindi.has-seen-welcome"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.speechService = HindiSpeechService()
        self.speechChecker = SpeechCheckerService()

        if let data = defaults.data(forKey: progressKey),
           let saved = try? JSONDecoder().decode(LearningProgress.self, from: data) {
            self.progress = saved
        } else {
            self.progress = .empty
        }
        self.isOnboarded = defaults.bool(forKey: onboardedKey)
    }

    var currentDayNumber: Int {
        progress.nextDayNumber
    }

    var currentDay: CourseDay {
        Curriculum.day(number: currentDayNumber)
    }

    func completeOnboarding() {
        isOnboarded = true
        defaults.set(true, forKey: onboardedKey)
    }

    func isDayUnlocked(_ number: Int) -> Bool {
        guard (1...30).contains(number) else { return false }
        return number == 1 || progress.completedDays.contains(number - 1)
    }

    func record(prompt: PhrasePrompt, correct: Bool, confidence: Confidence?) {
        progress.attempts += 1
        if correct {
            progress.correct += 1
            progress.phraseCorrect[prompt.id, default: 0] += 1
        }

        let skillKey = prompt.skill.rawValue
        progress.attemptsBySkill[skillKey, default: 0] += 1
        if correct {
            progress.correctBySkill[skillKey, default: 0] += 1
        }

        if let confidence {
            progress.confidenceChecks += 1
            if confidence == .guessed {
                progress.guessedChecks += 1
            }
        }
        progress.lastActivity = Date()
        persist()
    }

    func recordConfidence(_ confidence: Confidence) {
        recordConfidence(confidence, for: nil, correct: nil)
    }

    func recordConfidence(_ confidence: Confidence, for prompt: PhrasePrompt?, correct: Bool?) {
        progress.confidenceChecks += 1
        if confidence == .guessed {
            progress.guessedChecks += 1
        }
        if let prompt, let correct {
            scheduleReview(for: prompt, correct: correct, confidence: confidence)
        }
        progress.lastActivity = Date()
        persist()
    }

    func dueReviewPrompts(excluding promptIDs: Set<String>, limit: Int, now: Date = Date()) -> [PhrasePrompt] {
        guard limit > 0 else { return [] }
        let promptsByID = Dictionary(uniqueKeysWithValues: Curriculum.allDays.flatMap(\.prompts).map { ($0.id, $0) })
        return progress.reviewDueByPrompt
            .filter { entry in
                entry.value <= now && !promptIDs.contains(entry.key)
            }
            .sorted { lhs, rhs in
                if lhs.value == rhs.value { return lhs.key < rhs.key }
                return lhs.value < rhs.value
            }
            .compactMap { promptsByID[$0.key] }
            .prefix(limit)
            .map { $0 }
    }

    var dueReviewCount: Int {
        progress.dueReviewCount()
    }

    func completeDay(_ day: Int) {
        guard (1...30).contains(day), !progress.completedDays.contains(day) else { return }
        progress.completedDays.append(day)
        progress.completedDays.sort()
        progress.lastActivity = Date()
        persist()
    }

    func recordRoleplay() {
        progress.roleplaysCompleted += 1
        progress.lastActivity = Date()
        persist()
    }

    func recordSpeakingCheck() {
        progress.speakingChecks += 1
        progress.lastActivity = Date()
        persist()
    }

    func resetProgress() {
        progress = .empty
        persist()
    }

    func milestone(for day: Int) -> String {
        switch day {
        case 1...7:
            return "Decode the anchors in familiar home and food talk."
        case 8...14:
            return "Follow the rough point in short errands and plans."
        case 15...21:
            return "Track past, present, and future in a short exchange."
        default:
            return "Attempt predictable everyday conversations with more confidence."
        }
    }

    private func persist() {
        guard let data = try? JSONEncoder().encode(progress) else { return }
        defaults.set(data, forKey: progressKey)
    }

    private func scheduleReview(for prompt: PhrasePrompt, correct: Bool, confidence: Confidence) {
        let id = prompt.id
        let previousInterval = progress.reviewIntervalDays[id] ?? 0
        let confidentSuccess = correct && confidence == .knewIt
        // Immediate repeats are practice, not evidence of delayed retention.
        if confidentSuccess, let due = progress.reviewDueByPrompt[id], due > Date() { return }
        let nextStreak = confidentSuccess ? (progress.reviewStreakByPrompt[id] ?? 0) + 1 : 0
        let nextInterval = confidentSuccess
            ? min(previousInterval == 0 ? 2 : previousInterval * 2, 14)
            : 1

        progress.reviewIntervalDays[id] = nextInterval
        progress.reviewStreakByPrompt[id] = nextStreak
        progress.reviewDueByPrompt[id] = Calendar.current.date(byAdding: .day, value: nextInterval, to: Date()) ?? Date().addingTimeInterval(Double(nextInterval) * 86_400)

        if nextStreak >= 2 {
            if !progress.retainedPromptIDs.contains(id) {
                progress.retainedPromptIDs.append(id)
                progress.retainedPromptIDs.sort()
            }
        } else {
            progress.retainedPromptIDs.removeAll { $0 == id }
        }
    }
}
