import SwiftUI

enum PesaColors {
    static let ink = Color(red: 0.07, green: 0.14, blue: 0.13)
    static let moss = Color(red: 0.08, green: 0.36, blue: 0.31)
    static let mossLight = Color(red: 0.83, green: 0.92, blue: 0.87)
    static let coral = Color(red: 0.82, green: 0.31, blue: 0.22)
    static let coralLight = Color(red: 0.98, green: 0.88, blue: 0.82)
    static let sand = Color(red: 0.97, green: 0.95, blue: 0.90)
    static let paper = Color.white.opacity(0.78)
    static let gold = Color(red: 0.88, green: 0.63, blue: 0.22)
    static let slate = Color(red: 0.32, green: 0.39, blue: 0.37)
}

struct PesaBackground: View {
    var body: some View {
        ZStack {
            PesaColors.sand.ignoresSafeArea()
            Circle()
                .fill(PesaColors.mossLight.opacity(0.42))
                .frame(width: 260, height: 260)
                .blur(radius: 5)
                .offset(x: 170, y: -330)
            Circle()
                .fill(PesaColors.coralLight.opacity(0.55))
                .frame(width: 220, height: 220)
                .blur(radius: 8)
                .offset(x: -170, y: 390)
        }
    }
}

struct CardSurface<Content: View>: View {
    let content: Content
    var padding: CGFloat = 18

    init(padding: CGFloat = 18, @ViewBuilder content: () -> Content) {
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        content
            .padding(padding)
            .background(PesaColors.paper, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(PesaColors.ink.opacity(0.06), lineWidth: 1)
            }
            .shadow(color: PesaColors.ink.opacity(0.06), radius: 15, y: 7)
    }
}

struct EyebrowText: View {
    let text: String

    var body: some View {
        Text(text.uppercased())
            .font(.caption.weight(.bold))
            .tracking(1.2)
            .foregroundStyle(PesaColors.coral)
    }
}

struct TamilLabel: View {
    let tamil: String

    var body: some View {
        Text(tamil)
            .font(.subheadline)
            .foregroundStyle(PesaColors.slate)
            .lineSpacing(2)
    }
}

struct PrimaryActionButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
        }
        .buttonStyle(.borderedProminent)
        .tint(PesaColors.moss)
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct ProgressRing: View {
    let progress: Double
    var tint: Color = PesaColors.coral
    var lineWidth: CGFloat = 11

    var body: some View {
        ZStack {
            Circle()
                .stroke(PesaColors.ink.opacity(0.09), lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: min(max(progress, 0), 1))
                .stroke(tint, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 0.35), value: progress)
        }
    }
}

struct AudioButton: View {
    let title: String
    let phrase: String
    let speechText: String?
    let resourceName: String?
    let slow: Bool
    let onPlay: (() -> Void)?

    @EnvironmentObject private var speech: HindiSpeechService

    init(title: String = "Listen", phrase: String, speechText: String? = nil, resourceName: String? = nil, slow: Bool = false, onPlay: (() -> Void)? = nil) {
        self.title = title
        self.phrase = phrase
        self.speechText = speechText
        self.resourceName = resourceName
        self.slow = slow
        self.onPlay = onPlay
    }

    var body: some View {
        Button {
            if speech.isSpeaking {
                speech.stop()
            } else {
                onPlay?()
                speech.speak(phrase, speechText: speechText, resourceName: resourceName, slow: slow)
            }
        } label: {
            Label(title, systemImage: speech.isSpeaking ? "stop.fill" : "play.fill")
                .font(.subheadline.weight(.semibold))
        }
        .buttonStyle(.bordered)
        .tint(PesaColors.moss)
        .accessibilityLabel("\(title), Hindi audio")
    }
}

struct SkillMeter: View {
    let skill: SkillArea
    let value: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(skill.title).font(.subheadline.weight(.semibold))
                    Text(skill.tamil).font(.caption).foregroundStyle(PesaColors.slate)
                }
                Spacer()
                Text("\(value)%")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(PesaColors.moss)
            }
            GeometryReader { proxy in
                Capsule()
                    .fill(PesaColors.ink.opacity(0.08))
                    .overlay(alignment: .leading) {
                        Capsule()
                            .fill(value >= 70 ? PesaColors.moss : PesaColors.gold)
                            .frame(width: proxy.size.width * CGFloat(value) / 100)
                    }
            }
            .frame(height: 8)
        }
    }
}
