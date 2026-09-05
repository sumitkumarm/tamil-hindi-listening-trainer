import SwiftUI

struct ProgressDashboardView: View {
    @EnvironmentObject private var model: AppModel
    @State private var showResetConfirmation = false

    var body: some View {
        ZStack {
            PesaBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    ProgressHero(progress: model.progress)
                    ProgressStats(progress: model.progress)
                    SkillSection(progress: model.progress)
                    MilestoneSection(progress: model.progress)
                    Button("Reset local progress", role: .destructive) {
                        showResetConfirmation = true
                    }
                    .font(.subheadline.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                    .confirmationDialog("Reset your local practice map?", isPresented: $showResetConfirmation, titleVisibility: .visible) {
                        Button("Reset progress", role: .destructive) { model.resetProgress() }
                        Button("Keep progress", role: .cancel) { }
                    } message: {
                        Text("Completed days and practice counts will return to zero on this device.")
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 18)
            }
        }
        .navigationTitle("Your progress")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct ProgressHero: View {
    let progress: LearningProgress

    var body: some View {
        CardSurface {
            HStack(spacing: 18) {
                ZStack {
                    ProgressRing(progress: Double(progress.completedDayCount) / 30.0, tint: PesaColors.coral, lineWidth: 10)
                    VStack(spacing: 0) {
                        Text("\(progress.completedDayCount)")
                            .font(.title.weight(.black))
                        Text("/ 30")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(PesaColors.slate)
                    }
                }
                .frame(width: 95, height: 95)
                VStack(alignment: .leading, spacing: 7) {
                    EyebrowText(text: "Comprehension map")
                    Text(progress.completedDayCount == 0 ? "Start with one small exchange." : "Your listening habit has a shape now.")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(PesaColors.ink)
                    Text("Accuracy is a clue, not a grade. Guesses tell the next review where to return.")
                        .font(.caption)
                        .foregroundStyle(PesaColors.slate)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
}

private struct ProgressStats: View {
    let progress: LearningProgress

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 11) {
            StatTile(value: "\(progress.attempts)", label: "listening tries", icon: "ear.fill")
            StatTile(value: "\(progress.averageAccuracy)%", label: "overall accuracy", icon: "scope")
            StatTile(value: "\(progress.roleplaysCompleted)", label: "roleplays", icon: "bubble.left.and.bubble.right")
            StatTile(value: "\(progress.speakingChecks)", label: "speaking tries", icon: "waveform")
            StatTile(value: "\(progress.retainedPromptCount)", label: "recalled on spaced reviews", icon: "brain.head.profile")
            StatTile(value: "\(progress.dueReviewCount())", label: "reviews due", icon: "arrow.clockwise")
        }
    }
}

private struct StatTile: View {
    let value: String
    let label: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            Image(systemName: icon)
                .foregroundStyle(PesaColors.coral)
            Text(value)
                .font(.title2.weight(.black))
                .foregroundStyle(PesaColors.ink)
            Text(label)
                .font(.caption)
                .foregroundStyle(PesaColors.slate)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(PesaColors.paper, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

private struct SkillSection: View {
    let progress: LearningProgress

    var body: some View {
        VStack(alignment: .leading, spacing: 11) {
            Text("Skills that matter in a conversation")
                .font(.headline)
                .foregroundStyle(PesaColors.ink)
            CardSurface {
                VStack(spacing: 17) {
                    ForEach(SkillArea.allCases) { skill in
                        SkillMeter(skill: skill, value: progress.accuracy(for: skill))
                    }
                }
            }
        }
    }
}

private struct MilestoneSection: View {
    let progress: LearningProgress

    private let milestones: [(day: Int, title: String, detail: String)] = [
        (7, "Anchor checkpoint", "Recognize common home, food, and work anchors."),
        (14, "Errand checkpoint", "Follow the rough point through a short plan."),
        (21, "Time checkpoint", "Separate past, present, and future in context."),
        (30, "Conversation mission", "Attempt predictable exchanges and repair a miss.")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 11) {
            Text("Milestones")
                .font(.headline)
                .foregroundStyle(PesaColors.ink)
            CardSurface {
                VStack(spacing: 15) {
                    ForEach(milestones, id: \.day) { milestone in
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: progress.completedDayCount >= milestone.day ? "checkmark.circle.fill" : "circle")
                                .font(.title3)
                                .foregroundStyle(progress.completedDayCount >= milestone.day ? PesaColors.moss : PesaColors.ink.opacity(0.22))
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Day \(milestone.day) · \(milestone.title)")
                                    .font(.subheadline.weight(.bold))
                                    .foregroundStyle(PesaColors.ink)
                                Text(milestone.detail)
                                    .font(.caption)
                                    .foregroundStyle(PesaColors.slate)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            Spacer()
                        }
                        if milestone.day != milestones.last?.day { Divider() }
                    }
                }
            }
            Text("These milestones describe practice coverage, not guaranteed fluency or a test score.")
                .font(.caption)
                .foregroundStyle(PesaColors.slate)
        }
    }
}
