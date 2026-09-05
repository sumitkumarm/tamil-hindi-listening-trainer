import SwiftUI

struct LessonSessionView: View {
    @EnvironmentObject private var model: AppModel
    @EnvironmentObject private var speech: HindiSpeechService
    @Environment(\.dismiss) private var dismiss

    let day: CourseDay
    @State private var sessionPrompts: [PhrasePrompt]
    @State private var reviewPromptIDs: Set<String> = []
    @State private var promptIndex = 0
    @State private var didListen = false
    @State private var selectedChoice: String?
    @State private var wasCorrect = false
    @State private var confidence: Confidence?
    @State private var correctCount = 0
    @State private var completed = false

    init(day: CourseDay) {
        self.day = day
        _sessionPrompts = State(initialValue: day.prompts)
    }

    private var prompt: PhrasePrompt { sessionPrompts[promptIndex] }
    private var sessionProgress: Double { Double(promptIndex + (selectedChoice == nil ? 0 : 1)) / Double(sessionPrompts.count) }

    var body: some View {
        ZStack {
            PesaBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    if completed {
                        SessionCompleteCard(day: day, correct: correctCount, total: sessionPrompts.count, reviewCount: reviewPromptIDs.count, retainedCount: model.progress.retainedPromptCount) {
                            dismiss()
                        }
                    } else {
                        SessionHeader(day: day, promptIndex: promptIndex, totalCount: sessionPrompts.count, reviewCount: reviewPromptIDs.count, progress: sessionProgress)
                        PromptRound(prompt: prompt, isReview: reviewPromptIDs.contains(prompt.id), hasListened: didListen, selectedChoice: selectedChoice, wasCorrect: wasCorrect, confidence: confidence, answer: answer, chooseConfidence: chooseConfidence, markListened: markListened)
                        if selectedChoice != nil {
                            Button(action: advance) {
                                Label(promptIndex == sessionPrompts.count - 1 ? "Finish listening round" : "Next listening round", systemImage: "arrow.right")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(PesaColors.moss)
                            .disabled(confidence == nil)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 18)
            }
        }
        .navigationTitle("Day \(day.number) practice")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: loadReviewPrompts)
        .onDisappear { speech.stop() }
    }

    private func loadReviewPrompts() {
        guard sessionPrompts.count == day.prompts.count else { return }
        let currentIDs = Set(day.prompts.map(\.id))
        let reviews = model.dueReviewPrompts(excluding: currentIDs, limit: 4)
        guard !reviews.isEmpty else { return }
        sessionPrompts.append(contentsOf: reviews)
        reviewPromptIDs = Set(reviews.map(\.id))
    }

    private func markListened() {
        didListen = true
    }

    private func answer(_ choice: String) {
        guard selectedChoice == nil else { return }
        selectedChoice = choice
        wasCorrect = choice == prompt.correctChoice
        if wasCorrect { correctCount += 1 }
        model.record(prompt: prompt, correct: wasCorrect, confidence: nil)
    }

    private func chooseConfidence(_ value: Confidence) {
        guard confidence == nil else { return }
        confidence = value
        model.recordConfidence(value, for: prompt, correct: wasCorrect)
    }

    private func advance() {
        guard confidence != nil else { return }
        if promptIndex < sessionPrompts.count - 1 {
            promptIndex += 1
            didListen = false
            selectedChoice = nil
            confidence = nil
            wasCorrect = false
        } else {
            model.completeDay(day.number)
            completed = true
        }
    }
}

private struct SessionHeader: View {
    let day: CourseDay
    let promptIndex: Int
    let totalCount: Int
    let reviewCount: Int
    let progress: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                EyebrowText(text: "Listen + recall")
                Spacer()
                Text("Round \(promptIndex + 1) of \(totalCount)")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(PesaColors.slate)
            }
            Text(day.focus)
                .font(.title3.weight(.bold))
                .foregroundStyle(PesaColors.ink)
            GeometryReader { proxy in
                Capsule()
                    .fill(PesaColors.ink.opacity(0.08))
                    .overlay(alignment: .leading) {
                        Capsule()
                            .fill(PesaColors.coral)
                            .frame(width: max(8, proxy.size.width * progress))
                    }
            }
            .frame(height: 9)
            Text(reviewCount == 0 ? "Audio first. Your answer stays private until you choose one." : "Audio first. \(reviewCount) due review\(reviewCount == 1 ? "" : "s") are woven into this short pass.")
                .font(.caption)
                .foregroundStyle(PesaColors.slate)
        }
    }
}

private struct PromptRound: View {
    @EnvironmentObject private var speech: HindiSpeechService

    let prompt: PhrasePrompt
    let isReview: Bool
    let hasListened: Bool
    let selectedChoice: String?
    let wasCorrect: Bool
    let confidence: Confidence?
    let answer: (String) -> Void
    let chooseConfidence: (Confidence) -> Void
    let markListened: () -> Void

    var body: some View {
        CardSurface {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Label(prompt.mode.label, systemImage: prompt.mode == .reply ? "bubble.left" : "ear.fill")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(PesaColors.moss)
                    Spacer()
                    if isReview {
                        Text("Due review")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(PesaColors.coral)
                    }
                    Text(prompt.skill.title)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(PesaColors.slate)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Listen to the line")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(PesaColors.ink)
                    Text("Replay once slowly if you want to hear the shape again.")
                        .font(.subheadline)
                        .foregroundStyle(PesaColors.slate)
                    HStack(spacing: 10) {
                        AudioButton(title: "Play Hindi", phrase: prompt.phrase, speechText: prompt.speechText, resourceName: prompt.id, onPlay: markListened)
                        AudioButton(title: "Slow replay", phrase: prompt.phrase, speechText: prompt.speechText, resourceName: prompt.id, slow: true, onPlay: markListened)
                    }
                    if !speech.statusMessage.isEmpty {
                        Text(speech.statusMessage)
                            .font(.caption)
                            .foregroundStyle(PesaColors.coral)
                    }
                }
                Divider()
                if hasListened {
                    Text(prompt.question)
                        .font(.headline)
                        .foregroundStyle(PesaColors.ink)
                        .fixedSize(horizontal: false, vertical: true)
                    VStack(spacing: 9) {
                        ForEach(prompt.choices, id: \.self) { choice in
                            ChoiceRow(choice: choice, selectedChoice: selectedChoice, correctChoice: prompt.correctChoice, answer: answer)
                        }
                    }
                } else {
                    Label("Listen once to unlock the choices.", systemImage: "lock.open")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(PesaColors.moss)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                if selectedChoice != nil {
                    RevealBlock(prompt: prompt, wasCorrect: wasCorrect)
                    ConfidenceBlock(selection: confidence, choose: chooseConfidence)
                }
            }
        }
    }

}

private struct ChoiceRow: View {
    let choice: String
    let selectedChoice: String?
    let correctChoice: String
    let answer: (String) -> Void

    var isCorrect: Bool { choice == correctChoice }
    var isSelected: Bool { choice == selectedChoice }

    var body: some View {
        Button { answer(choice) } label: {
            HStack(alignment: .center, spacing: 12) {
                Text(choice)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(PesaColors.ink)
                    .multilineTextAlignment(.leading)
                Spacer()
                if selectedChoice != nil, isCorrect {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(PesaColors.moss)
                } else if isSelected {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(PesaColors.coral)
                } else {
                    Image(systemName: "circle")
                        .foregroundStyle(PesaColors.ink.opacity(0.2))
                }
            }
            .padding(13)
            .background(backgroundColor, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(borderColor, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .disabled(selectedChoice != nil)
        .accessibilityHint(selectedChoice == nil ? "Choose this answer" : "Answer revealed")
    }

    private var backgroundColor: Color {
        guard selectedChoice != nil else { return PesaColors.ink.opacity(0.035) }
        if isCorrect { return PesaColors.mossLight }
        if isSelected { return PesaColors.coralLight }
        return PesaColors.ink.opacity(0.025)
    }

    private var borderColor: Color {
        guard selectedChoice != nil else { return PesaColors.ink.opacity(0.06) }
        if isCorrect { return PesaColors.moss.opacity(0.35) }
        if isSelected { return PesaColors.coral.opacity(0.35) }
        return PesaColors.ink.opacity(0.04)
    }
}

private struct RevealBlock: View {
    let prompt: PhrasePrompt
    let wasCorrect: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(wasCorrect ? "You caught it" : "Let's make the pattern stick", systemImage: wasCorrect ? "checkmark.seal.fill" : "arrow.uturn.forward.circle.fill")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(wasCorrect ? PesaColors.moss : PesaColors.coral)
            Text(prompt.phrase)
                .font(.title3.weight(.bold))
                .foregroundStyle(PesaColors.ink)
            HStack(alignment: .top, spacing: 12) {
                MeaningColumn(title: "Tamil bridge", text: prompt.tamil)
                Divider()
                MeaningColumn(title: "English gist", text: prompt.english)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            VStack(alignment: .leading, spacing: 5) {
                Text("Pattern: \(prompt.pattern)")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(PesaColors.moss)
                Text(prompt.note)
                    .font(.caption)
                    .foregroundStyle(PesaColors.slate)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(12)
            .background(PesaColors.mossLight.opacity(0.6), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .padding(14)
        .background(PesaColors.sand.opacity(0.75), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

private struct MeaningColumn: View {
    let title: String
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title.uppercased())
                .font(.caption2.weight(.bold))
                .tracking(0.8)
                .foregroundStyle(PesaColors.coral)
            Text(text)
                .font(.subheadline)
                .foregroundStyle(PesaColors.ink)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct ConfidenceBlock: View {
    let selection: Confidence?
    let choose: (Confidence) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("How did that feel?")
                .font(.caption.weight(.bold))
                .foregroundStyle(PesaColors.slate)
            HStack(spacing: 9) {
                ConfidenceButton(title: "I knew it", icon: "hand.thumbsup.fill", isSelected: selection == .knewIt) {
                    choose(.knewIt)
                }
                ConfidenceButton(title: "I guessed", icon: "questionmark", isSelected: selection == .guessed) {
                    choose(.guessed)
                }
            }
            Text("Guesses are useful data; they bring a pattern back for another pass.")
                .font(.caption2)
                .foregroundStyle(PesaColors.slate)
        }
    }
}

private struct ConfidenceButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: icon)
                .font(.caption.weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
        }
        .buttonStyle(.bordered)
        .tint(isSelected ? PesaColors.moss : PesaColors.slate)
        .disabled(isSelected)
    }
}

private struct SessionCompleteCard: View {
    let day: CourseDay
    let correct: Int
    let total: Int
    let reviewCount: Int
    let retainedCount: Int
    let close: () -> Void

    var body: some View {
        CardSurface {
            VStack(alignment: .leading, spacing: 18) {
                Image(systemName: "ear.and.waveform")
                    .font(.system(size: 38, weight: .bold))
                    .foregroundStyle(PesaColors.coral)
                EyebrowText(text: "Listening round complete")
                Text("You made time for the pattern.")
                    .font(.system(size: 31, weight: .black, design: .rounded))
                    .foregroundStyle(PesaColors.ink)
                Text("\(correct) of \(total) gist checks landed this time. Keep the ones you guessed in the next pass; recognition grows through return visits.")
                    .font(.body)
                    .foregroundStyle(PesaColors.slate)
                    .fixedSize(horizontal: false, vertical: true)
                Divider()
                Text("Next target")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(PesaColors.coral)
                Text(day.outcome)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(PesaColors.ink)
                RetentionNote(reviewCount: reviewCount, retainedCount: retainedCount)
                NavigationLink {
                    RoleplayView(day: day)
                } label: {
                    Label("Try the conversation", systemImage: "bubble.left.and.bubble.right")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.borderedProminent)
                .tint(PesaColors.moss)
                Button("Done for today", action: close)
                    .font(.subheadline.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(PesaColors.coral)
            }
        }
    }
}

private struct RetentionNote: View {
    let reviewCount: Int
    let retainedCount: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label("Lesson complete · retention keeps working", systemImage: "arrow.triangle.2.circlepath")
                .font(.caption.weight(.bold))
                .foregroundStyle(PesaColors.moss)
            Text(reviewCount == 0
                 ? "Missed or guessed lines enter a spaced review queue before they count as retained."
                 : "This pass included \(reviewCount) due review\(reviewCount == 1 ? "" : "s"). \(retainedCount) prompt\(retainedCount == 1 ? " is" : "s are") currently retained after confident returns.")
                .font(.caption)
                .foregroundStyle(PesaColors.slate)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .background(PesaColors.mossLight.opacity(0.55), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}
