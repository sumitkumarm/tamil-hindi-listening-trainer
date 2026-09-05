import SwiftUI

struct TodayView: View {
    @EnvironmentObject private var model: AppModel

    var body: some View {
        ZStack {
            PesaBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    TodayHeader(day: model.currentDay, completedDays: model.progress.completedDayCount)
                    MissionCard(day: model.currentDay, isComplete: model.progress.isDayComplete(model.currentDay.number))
                    SkillSnapshot(progress: model.progress)
                    PracticePromise()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 18)
            }
        }
        .navigationTitle("Pesa Hindi")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct TodayHeader: View {
    let day: CourseDay
    let completedDays: Int

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                EyebrowText(text: "Day \(day.number) of 30")
                Text("Understand first.\nAnswer next.")
                    .font(.system(size: 31, weight: .black, design: .rounded))
                    .foregroundStyle(PesaColors.ink)
                    .fixedSize(horizontal: false, vertical: true)
                Text("ஒரு நாளில் ஒரு சிறிய உரையாடல்")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(PesaColors.moss)
            }
            Spacer(minLength: 4)
            ZStack {
                ProgressRing(progress: Double(completedDays) / 30.0, tint: PesaColors.coral, lineWidth: 9)
                VStack(spacing: 0) {
                    Text("\(completedDays)")
                        .font(.title2.weight(.black))
                    Text("done")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(PesaColors.slate)
                }
            }
            .frame(width: 78, height: 78)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("\(completedDays) of 30 days complete")
        }
    }
}

private struct MissionCard: View {
    let day: CourseDay
    let isComplete: Bool

    var body: some View {
        CardSurface {
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 5) {
                        EyebrowText(text: "Today's mission")
                        Text(day.title)
                            .font(.title2.weight(.bold))
                            .foregroundStyle(PesaColors.ink)
                        TamilLabel(tamil: day.tamilTitle)
                    }
                    Spacer()
                    Label("\(day.minutes) min", systemImage: "clock")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(PesaColors.moss)
                }
                Text(day.outcome)
                    .font(.body)
                    .foregroundStyle(PesaColors.slate)
                    .fixedSize(horizontal: false, vertical: true)
                HStack(spacing: 8) {
                    MissionPill(text: "\(day.promptCount) listen + recall", color: PesaColors.mossLight)
                    MissionPill(text: "1 roleplay", color: PesaColors.coralLight)
                }
                NavigationLink {
                    LessonSessionView(day: day)
                } label: {
                    Label(isComplete ? "Repeat today's practice" : "Start today's practice", systemImage: isComplete ? "arrow.clockwise" : "arrow.right")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.borderedProminent)
                .tint(PesaColors.moss)
                NavigationLink {
                    RoleplayView(day: day)
                } label: {
                    Label("Jump to the conversation", systemImage: "bubble.left.and.bubble.right")
                        .font(.subheadline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 4)
                }
                .buttonStyle(.plain)
                .foregroundStyle(PesaColors.coral)
            }
        }
    }
}

private struct MissionPill: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(.caption.weight(.semibold))
            .foregroundStyle(PesaColors.ink)
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(color, in: Capsule())
    }
}

private struct SkillSnapshot: View {
    let progress: LearningProgress

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your listening map")
                .font(.headline)
                .foregroundStyle(PesaColors.ink)
            Text("A useful picture of what is sticking, without points or pressure.")
                .font(.subheadline)
                .foregroundStyle(PesaColors.slate)
            CardSurface {
                VStack(spacing: 16) {
                    ForEach(SkillArea.allCases) { skill in
                        SkillMeter(skill: skill, value: progress.accuracy(for: skill))
                    }
                }
            }
        }
    }
}

private struct PracticePromise: View {
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "ear.and.waveform")
                .font(.title3.weight(.bold))
                .foregroundStyle(PesaColors.coral)
            VStack(alignment: .leading, spacing: 5) {
                Text("The promise of this course")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(PesaColors.ink)
                Text("Thirty short practices can build a reliable listening habit. They cannot promise fluency, and the app will show the target honestly.")
                    .font(.caption)
                    .foregroundStyle(PesaColors.slate)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.vertical, 8)
    }
}
