import SwiftUI

struct RoleplayView: View {
    @EnvironmentObject private var model: AppModel
    @EnvironmentObject private var speech: HindiSpeechService
    @Environment(\.dismiss) private var dismiss

    let day: CourseDay
    @State private var selectedReply: String?
    @State private var didFinish = false

    private var scenario: RoleplayScenario { day.roleplay }

    var body: some View {
        ZStack {
            PesaBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 17) {
                    if didFinish {
                        RoleplayComplete(day: day, close: dismiss.callAsFunction)
                    } else {
                        RoleplayHeader(day: day, scenario: scenario)
                        ConversationCard(scenario: scenario, selectedReply: selectedReply, selectReply: selectReply)
                        if selectedReply != nil {
                            FeedbackCard(scenario: scenario, selectedReply: selectedReply ?? "")
                            AudioButton(title: "Hear the useful reply", phrase: scenario.bestChoice, speechText: scenario.bestChoiceSpeechText)
                            Button(action: finishRoleplay) {
                                Label("Finish this conversation", systemImage: "checkmark")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(PesaColors.moss)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 18)
            }
        }
        .navigationTitle("Roleplay")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear { speech.stop() }
    }

    private func selectReply(_ reply: String) {
        guard selectedReply == nil else { return }
        selectedReply = reply
    }

    private func finishRoleplay() {
        guard !didFinish else { return }
        model.recordRoleplay()
        didFinish = true
    }
}

private struct RoleplayHeader: View {
    let day: CourseDay
    let scenario: RoleplayScenario

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            EyebrowText(text: "One useful exchange")
            Text(scenario.title)
                .font(.system(size: 30, weight: .black, design: .rounded))
                .foregroundStyle(PesaColors.ink)
            Text("Day \(day.number) · \(scenario.setting)")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(PesaColors.moss)
            Text("Choose the reply that keeps the conversation moving. Perfect grammar is not the point.")
                .font(.subheadline)
                .foregroundStyle(PesaColors.slate)
        }
    }
}

private struct ConversationCard: View {
    let scenario: RoleplayScenario
    let selectedReply: String?
    let selectReply: (String) -> Void

    var body: some View {
        CardSurface {
            VStack(alignment: .leading, spacing: 14) {
                ChatBubble(speaker: "Friend", text: scenario.opening, tamil: scenario.openingTamil, english: scenario.openingEnglish, color: PesaColors.mossLight)
                AudioButton(title: "Hear opening", phrase: scenario.opening, speechText: scenario.openingSpeechText)
                Text("Your reply")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(PesaColors.coral)
                    .padding(.top, 3)
                ForEach(scenario.choices, id: \.self) { reply in
                    Button { selectReply(reply) } label: {
                        HStack(alignment: .top, spacing: 10) {
                            Text(reply)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(PesaColors.ink)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            Image(systemName: selectedReply == reply ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(selectedReply == reply ? PesaColors.moss : PesaColors.ink.opacity(0.18))
                        }
                        .padding(13)
                        .background(rowColor(reply), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay {
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(rowBorder(reply), lineWidth: 1)
                        }
                    }
                    .buttonStyle(.plain)
                    .disabled(selectedReply != nil)
                }
            }
        }
    }

    private func rowColor(_ reply: String) -> Color {
        guard selectedReply != nil else { return PesaColors.ink.opacity(0.035) }
        return reply == scenario.bestChoice ? PesaColors.mossLight : (reply == selectedReply ? PesaColors.coralLight : PesaColors.ink.opacity(0.025))
    }

    private func rowBorder(_ reply: String) -> Color {
        guard selectedReply != nil else { return PesaColors.ink.opacity(0.06) }
        return reply == scenario.bestChoice ? PesaColors.moss.opacity(0.35) : PesaColors.ink.opacity(0.04)
    }
}

private struct ChatBubble: View {
    let speaker: String
    let text: String
    let tamil: String
    let english: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(speaker.uppercased())
                .font(.caption2.weight(.bold))
                .tracking(1)
                .foregroundStyle(PesaColors.moss)
            Text(text)
                .font(.title3.weight(.bold))
                .foregroundStyle(PesaColors.ink)
            Text(tamil)
                .font(.subheadline)
                .foregroundStyle(PesaColors.slate)
            Text(english)
                .font(.caption)
                .italic()
                .foregroundStyle(PesaColors.slate)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color, in: RoundedRectangle(cornerRadius: 17, style: .continuous))
    }
}

private struct FeedbackCard: View {
    let scenario: RoleplayScenario
    let selectedReply: String

    var body: some View {
        CardSurface {
            VStack(alignment: .leading, spacing: 9) {
                Label(selectedReply == scenario.bestChoice ? "That keeps it moving" : "A clearer next turn", systemImage: selectedReply == scenario.bestChoice ? "checkmark.seal.fill" : "arrow.uturn.forward.circle.fill")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(selectedReply == scenario.bestChoice ? PesaColors.moss : PesaColors.coral)
                Text("Useful reply")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(PesaColors.coral)
                Text(scenario.bestChoice)
                    .font(.title3.weight(.bold))
                    .foregroundStyle(PesaColors.ink)
                Text(scenario.helpfulReplyTamil)
                    .font(.subheadline)
                    .foregroundStyle(PesaColors.slate)
                Text(scenario.helpfulReplyEnglish)
                    .font(.caption)
                    .italic()
                    .foregroundStyle(PesaColors.slate)
                Divider()
                Text(scenario.tip)
                    .font(.caption)
                    .foregroundStyle(PesaColors.slate)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

private struct RoleplayComplete: View {
    let day: CourseDay
    let close: () -> Void

    var body: some View {
        CardSurface {
            VStack(alignment: .leading, spacing: 16) {
                Image(systemName: "bubble.left.and.bubble.right.fill")
                    .font(.system(size: 38, weight: .bold))
                    .foregroundStyle(PesaColors.coral)
                EyebrowText(text: "Conversation saved")
                Text("You kept a real turn alive.")
                    .font(.system(size: 30, weight: .black, design: .rounded))
                    .foregroundStyle(PesaColors.ink)
                Text("The next useful step is a quick speaking try. Use the Speak tab whenever you want to rehearse this line again.")
                    .font(.body)
                    .foregroundStyle(PesaColors.slate)
                    .fixedSize(horizontal: false, vertical: true)
                Text("Day \(day.number) · \(day.roleplay.title)")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(PesaColors.moss)
                Button("Done", action: close)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .buttonStyle(.borderedProminent)
                    .tint(PesaColors.moss)
            }
        }
    }
}
