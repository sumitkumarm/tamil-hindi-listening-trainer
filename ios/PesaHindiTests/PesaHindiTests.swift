import XCTest
@testable import PesaHindi

final class CurriculumTests: XCTestCase {
    func testEveryListeningLineHasAuthoredHindiSpeech() {
        for day in Curriculum.allDays {
            for prompt in day.prompts {
                XCTAssertNotNil(HindiSpeechText.prompt[prompt.id])
            }
            XCTAssertNotNil(HindiSpeechText.roleplayOpening[day.roleplay.id])
            XCTAssertNotNil(HindiSpeechText.roleplayReply[day.roleplay.id])
        }
    }
    func testCurriculumHasThirtyOrderedDaysWithFourPromptsEach() {
        XCTAssertEqual(Curriculum.allDays.count, 30)
        XCTAssertEqual(Curriculum.allDays.map(\.number), Array(1...30))
        XCTAssertTrue(Curriculum.allDays.allSatisfy { day in
            day.prompts.count == 4 && day.minutes <= 15 && !day.roleplay.choices.isEmpty
        })
    }

    func testPromptAndRoleplayAnswersAreRepresentedInTheirChoices() {
        let prompts = Curriculum.allDays.flatMap(\.prompts)
        let promptIDs = prompts.map(\.id)

        XCTAssertEqual(Set(promptIDs).count, promptIDs.count)
        XCTAssertTrue(prompts.allSatisfy { prompt in
            !prompt.phrase.isEmpty &&
            !prompt.tamil.isEmpty &&
            !prompt.english.isEmpty &&
            prompt.choices.contains(prompt.correctChoice)
        })
        XCTAssertTrue(Curriculum.allDays.allSatisfy { day in
            day.roleplay.choices.contains(day.roleplay.bestChoice)
        })
    }
}

final class LearningProgressTests: XCTestCase {
    func testNextDayFollowsTheFirstIncompleteDay() {
        XCTAssertEqual(LearningProgress.empty.nextDayNumber, 1)

        var progress = LearningProgress.empty
        progress.completedDays = [1, 3]
        XCTAssertEqual(progress.nextDayNumber, 2)
        XCTAssertEqual(progress.completedDayCount, 2)

        progress.completedDays = Array(1...30)
        XCTAssertEqual(progress.nextDayNumber, 30)
    }

    func testAccuracyIsClampedAndEmptyProgressIsZero() {
        var progress = LearningProgress.empty
        XCTAssertEqual(progress.averageAccuracy, 0)

        progress.attempts = 2
        progress.correct = 3
        progress.attemptsBySkill[SkillArea.gist.rawValue] = 2
        progress.correctBySkill[SkillArea.gist.rawValue] = -1

        XCTAssertEqual(progress.averageAccuracy, 100)
        XCTAssertEqual(progress.accuracy(for: .gist), 0)
    }
}

@MainActor
final class AppModelTests: XCTestCase {
    func testImmediateRepeatsDoNotClaimDelayedRetention() {
        let suite = "PesaHindiTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        defer { defaults.removePersistentDomain(forName: suite) }
        let model = AppModel(defaults: defaults)
        let prompt = Curriculum.day(number: 1).prompts[0]
        model.recordConfidence(.knewIt, for: prompt, correct: true)
        let due = model.progress.reviewDueByPrompt[prompt.id]
        model.recordConfidence(.knewIt, for: prompt, correct: true)
        XCTAssertEqual(model.progress.retainedPromptCount, 0)
        XCTAssertEqual(model.progress.reviewDueByPrompt[prompt.id], due)
    }

    func testRetainedPhrasesStillReturnWhenDue() throws {
        var progress = LearningProgress.empty
        let prompt = Curriculum.day(number: 1).prompts[0]
        progress.retainedPromptIDs = [prompt.id]
        progress.reviewDueByPrompt[prompt.id] = Date().addingTimeInterval(-60)
        XCTAssertEqual(progress.dueReviewCount(), 1)
        let suite = "PesaHindiTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        defer { defaults.removePersistentDomain(forName: suite) }
        defaults.set(try JSONEncoder().encode(progress), forKey: "pesa-hindi.learning-progress")
        let model = AppModel(defaults: defaults)
        XCTAssertEqual(model.dueReviewPrompts(excluding: [], limit: 4).map(\.id), [prompt.id])
    }

    func testDayCompletionPersistsAndGuardsInvalidDays() {
        let suiteName = "PesaHindiTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defer { defaults.removePersistentDomain(forName: suiteName) }

        let model = AppModel(defaults: defaults)
        XCTAssertEqual(model.currentDayNumber, 1)
        XCTAssertTrue(model.isDayUnlocked(1))
        XCTAssertFalse(model.isDayUnlocked(2))

        model.completeDay(0)
        model.completeDay(1)
        model.completeDay(1)
        XCTAssertEqual(model.progress.completedDays, [1])
        XCTAssertEqual(model.currentDayNumber, 2)
        XCTAssertTrue(model.isDayUnlocked(2))
        XCTAssertFalse(model.isDayUnlocked(31))

        let reloaded = AppModel(defaults: defaults)
        XCTAssertEqual(reloaded.progress.completedDays, [1])
        XCTAssertEqual(reloaded.currentDayNumber, 2)
    }

    func testRecordingAnAnswerUpdatesOverallAndSkillAccuracy() {
        let suiteName = "PesaHindiTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defer { defaults.removePersistentDomain(forName: suiteName) }

        let model = AppModel(defaults: defaults)
        let prompt = Curriculum.day(number: 1).prompts[0]
        model.record(prompt: prompt, correct: true, confidence: .knewIt)
        model.record(prompt: prompt, correct: false, confidence: .guessed)

        XCTAssertEqual(model.progress.attempts, 2)
        XCTAssertEqual(model.progress.correct, 1)
        XCTAssertEqual(model.progress.averageAccuracy, 50)
        XCTAssertEqual(model.progress.accuracy(for: prompt.skill), 50)
        XCTAssertEqual(model.progress.confidenceChecks, 2)
        XCTAssertEqual(model.progress.guessedChecks, 1)
        XCTAssertEqual(model.progress.phraseCorrect[prompt.id], 1)
    }
}
