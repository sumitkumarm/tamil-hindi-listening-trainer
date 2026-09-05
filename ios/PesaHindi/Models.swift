import Foundation

enum AppTab: String, CaseIterable, Identifiable {
    case today
    case course
    case speak
    case progress

    var id: String { rawValue }

    var title: String {
        switch self {
        case .today: return "Today"
        case .course: return "30 days"
        case .speak: return "Speak"
        case .progress: return "Progress"
        }
    }

    var systemImage: String {
        switch self {
        case .today: return "sun.max.fill"
        case .course: return "map.fill"
        case .speak: return "waveform"
        case .progress: return "chart.bar.fill"
        }
    }
}

enum SkillArea: String, CaseIterable, Codable, Identifiable {
    case anchors
    case verbFamilies
    case gist
    case response

    var id: String { rawValue }

    var title: String {
        switch self {
        case .anchors: return "Anchor words"
        case .verbFamilies: return "Verb families"
        case .gist: return "Conversation gist"
        case .response: return "Fast replies"
        }
    }

    var tamil: String {
        switch self {
        case .anchors: return "முக்கிய சொற்கள்"
        case .verbFamilies: return "வினைச்சொல் குடும்பங்கள்"
        case .gist: return "உரையாடலின் கருத்து"
        case .response: return "வேகமான பதில்கள்"
        }
    }
}

enum PromptMode: String, Codable, Hashable {
    case meaning
    case anchor
    case timeClue
    case reply

    var label: String {
        switch self {
        case .meaning: return "Catch the gist"
        case .anchor: return "Find the anchor"
        case .timeClue: return "Hear the time clue"
        case .reply: return "Choose a useful reply"
        }
    }
}

enum Confidence: String, Codable, Hashable {
    case knewIt
    case guessed
}

struct PhrasePrompt: Identifiable, Codable, Hashable {
    let id: String
    let phrase: String
    let tamil: String
    let english: String
    let anchor: String
    let pattern: String
    let note: String
    let question: String
    let choices: [String]
    let correctChoice: String
    let mode: PromptMode
    let skill: SkillArea

    /// Romanization stays visible for the learner; the Hindi voice receives an
    /// authored Devanagari line so it does not read the romanization as English.
    var speechText: String {
        HindiSpeechText.prompt[id] ?? phrase
    }
}

struct RoleplayScenario: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let setting: String
    let opening: String
    let openingTamil: String
    let openingEnglish: String
    let choices: [String]
    let bestChoice: String
    let helpfulReplyTamil: String
    let helpfulReplyEnglish: String
    let tip: String

    var openingSpeechText: String {
        HindiSpeechText.roleplayOpening[id] ?? opening
    }

    var bestChoiceSpeechText: String {
        HindiSpeechText.roleplayReply[id] ?? bestChoice
    }
}

struct CourseDay: Identifiable, Codable, Hashable {
    let number: Int
    let title: String
    let tamilTitle: String
    let focus: String
    let outcome: String
    let minutes: Int
    let prompts: [PhrasePrompt]
    let roleplay: RoleplayScenario

    var id: Int { number }
    var promptCount: Int { prompts.count }
}

struct LearningProgress: Codable, Equatable {
    var completedDays: [Int] = []
    var attempts: Int = 0
    var correct: Int = 0
    var attemptsBySkill: [String: Int] = [:]
    var correctBySkill: [String: Int] = [:]
    var phraseCorrect: [String: Int] = [:]
    var confidenceChecks: Int = 0
    var guessedChecks: Int = 0
    var roleplaysCompleted: Int = 0
    var speakingChecks: Int = 0
    var lastActivity: Date?
    var reviewDueByPrompt: [String: Date] = [:]
    var reviewIntervalDays: [String: Int] = [:]
    var reviewStreakByPrompt: [String: Int] = [:]
    var retainedPromptIDs: [String] = []

    static let empty = LearningProgress()

    init() {}

    /// The progress file is local and may outlive a curriculum revision. Count only
    /// unique, in-range days so one bad value cannot make the ring exceed 30 days.
    var completedDayCount: Int {
        Set(completedDays.filter { (1...30).contains($0) }).count
    }

    var retainedPromptCount: Int {
        Set(retainedPromptIDs).count
    }

    func dueReviewCount(on date: Date = Date()) -> Int {
        return reviewDueByPrompt.reduce(into: 0) { count, entry in
            if entry.value <= date {
                count += 1
            }
        }
    }

    /// Returns the first day that still needs a pass. When the course is complete,
    /// keep Day 30 as the useful repeat target instead of inventing Day 31.
    var nextDayNumber: Int {
        (1...30).first(where: { !completedDays.contains($0) }) ?? 30
    }

    var averageAccuracy: Int {
        guard attempts > 0 else { return 0 }
        let ratio = min(max(Double(correct) / Double(attempts), 0), 1)
        return Int((ratio * 100).rounded())
    }

    func accuracy(for skill: SkillArea) -> Int {
        let key = skill.rawValue
        let total = attemptsBySkill[key] ?? 0
        guard total > 0 else { return 0 }
        let ratio = min(max(Double(correctBySkill[key] ?? 0) / Double(total), 0), 1)
        return Int((ratio * 100).rounded())
    }

    func isDayComplete(_ day: Int) -> Bool {
        completedDays.contains(day)
    }

    private enum CodingKeys: String, CodingKey {
        case completedDays, attempts, correct, attemptsBySkill, correctBySkill
        case phraseCorrect, confidenceChecks, guessedChecks, roleplaysCompleted
        case speakingChecks, lastActivity, reviewDueByPrompt, reviewIntervalDays
        case reviewStreakByPrompt, retainedPromptIDs
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        completedDays = try container.decodeIfPresent([Int].self, forKey: .completedDays) ?? []
        attempts = try container.decodeIfPresent(Int.self, forKey: .attempts) ?? 0
        correct = try container.decodeIfPresent(Int.self, forKey: .correct) ?? 0
        attemptsBySkill = try container.decodeIfPresent([String: Int].self, forKey: .attemptsBySkill) ?? [:]
        correctBySkill = try container.decodeIfPresent([String: Int].self, forKey: .correctBySkill) ?? [:]
        phraseCorrect = try container.decodeIfPresent([String: Int].self, forKey: .phraseCorrect) ?? [:]
        confidenceChecks = try container.decodeIfPresent(Int.self, forKey: .confidenceChecks) ?? 0
        guessedChecks = try container.decodeIfPresent(Int.self, forKey: .guessedChecks) ?? 0
        roleplaysCompleted = try container.decodeIfPresent(Int.self, forKey: .roleplaysCompleted) ?? 0
        speakingChecks = try container.decodeIfPresent(Int.self, forKey: .speakingChecks) ?? 0
        lastActivity = try container.decodeIfPresent(Date.self, forKey: .lastActivity)
        reviewDueByPrompt = try container.decodeIfPresent([String: Date].self, forKey: .reviewDueByPrompt) ?? [:]
        reviewIntervalDays = try container.decodeIfPresent([String: Int].self, forKey: .reviewIntervalDays) ?? [:]
        reviewStreakByPrompt = try container.decodeIfPresent([String: Int].self, forKey: .reviewStreakByPrompt) ?? [:]
        retainedPromptIDs = try container.decodeIfPresent([String].self, forKey: .retainedPromptIDs) ?? []
    }
}

extension CourseDay {
    var accessibilitySummary: String {
        "Day \(number), \(title). \(focus). \(outcome). About \(minutes) minutes."
    }
}
