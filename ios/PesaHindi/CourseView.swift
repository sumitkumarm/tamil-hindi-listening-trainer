import SwiftUI

struct CourseView: View {
    @EnvironmentObject private var model: AppModel

    var body: some View {
        ZStack {
            PesaBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        EyebrowText(text: "A listening path")
                        Text("Thirty days, one useful layer at a time")
                            .font(.system(size: 29, weight: .black, design: .rounded))
                            .foregroundStyle(PesaColors.ink)
                        Text("Days unlock in sequence so yesterday's patterns return inside a new situation. Repeat any open day when a form still feels slippery.")
                            .font(.subheadline)
                            .foregroundStyle(PesaColors.slate)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    CourseLegend()
                    LazyVStack(spacing: 11) {
                        ForEach(Curriculum.allDays) { day in
                            let unlocked = model.isDayUnlocked(day.number)
                            if unlocked {
                                NavigationLink {
                                    LessonSessionView(day: day)
                                } label: {
                                    DayRow(day: day, isUnlocked: true, isComplete: model.progress.isDayComplete(day.number))
                                }
                                .buttonStyle(.plain)
                            } else {
                                DayRow(day: day, isUnlocked: false, isComplete: false)
                                    .opacity(0.62)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 18)
            }
        }
        .navigationTitle("30-day path")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct CourseLegend: View {
    var body: some View {
        HStack(spacing: 10) {
            Label("Open", systemImage: "circle.fill")
            Label("Complete", systemImage: "checkmark.circle.fill")
            Label("Next", systemImage: "lock.fill")
        }
        .font(.caption.weight(.semibold))
        .foregroundStyle(PesaColors.slate)
        .symbolRenderingMode(.hierarchical)
    }
}

private struct DayRow: View {
    let day: CourseDay
    let isUnlocked: Bool
    let isComplete: Bool

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(isComplete ? PesaColors.moss : PesaColors.ink.opacity(isUnlocked ? 0.08 : 0.05))
                    .frame(width: 44, height: 44)
                if isComplete {
                    Image(systemName: "checkmark")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                } else if isUnlocked {
                    Text("\(day.number)")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(PesaColors.ink)
                } else {
                    Image(systemName: "lock.fill")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(PesaColors.slate)
                }
            }
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .firstTextBaseline) {
                    Text(day.title)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(PesaColors.ink)
                    Spacer()
                    Text("\(day.minutes)m")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(PesaColors.slate)
                }
                Text(day.focus)
                    .font(.caption)
                    .foregroundStyle(PesaColors.slate)
                    .lineLimit(2)
            }
            if isUnlocked {
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(PesaColors.coral)
            }
        }
        .padding(14)
        .background(PesaColors.paper, in: RoundedRectangle(cornerRadius: 19, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 19, style: .continuous)
                .stroke(PesaColors.ink.opacity(0.05), lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(day.accessibilitySummary)
        .accessibilityHint(isUnlocked ? "Open this day" : "Complete the previous day to unlock")
    }
}
