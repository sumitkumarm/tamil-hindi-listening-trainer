import SwiftUI

struct AppShellView: View {
    @EnvironmentObject private var model: AppModel
    @State private var selectedTab: AppTab = .today

    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                NavigationStack {
                    TodayView()
                }
                .tabItem { Label(AppTab.today.title, systemImage: AppTab.today.systemImage) }
                .tag(AppTab.today)

                NavigationStack {
                    CourseView()
                }
                .tabItem { Label(AppTab.course.title, systemImage: AppTab.course.systemImage) }
                .tag(AppTab.course)

                NavigationStack {
                    SpeakView()
                }
                .tabItem { Label(AppTab.speak.title, systemImage: AppTab.speak.systemImage) }
                .tag(AppTab.speak)

                NavigationStack {
                    ProgressDashboardView()
                }
                .tabItem { Label(AppTab.progress.title, systemImage: AppTab.progress.systemImage) }
                .tag(AppTab.progress)
            }
            .tint(PesaColors.moss)
            .opacity(model.isOnboarded ? 1 : 0)
            .disabled(!model.isOnboarded)

            if !model.isOnboarded {
                WelcomeView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: model.isOnboarded)
    }
}

struct WelcomeView: View {
    @EnvironmentObject private var model: AppModel

    var body: some View {
        ZStack {
            PesaBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Spacer(minLength: 34)
                    Image("PesaHindiMark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .accessibilityLabel("Pesa Hindi listening mark")
                    VStack(alignment: .leading, spacing: 10) {
                        EyebrowText(text: "Hindi through Tamil")
                        Text("Pesa Hindi")
                            .font(.system(size: 46, weight: .black, design: .rounded))
                            .foregroundStyle(PesaColors.ink)
                        Text("பேசி கற்றுக்கொள்")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(PesaColors.moss)
                        Text("Understand the rough point, then answer with your own useful line.")
                            .font(.title3)
                            .foregroundStyle(PesaColors.slate)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    CardSurface {
                        VStack(alignment: .leading, spacing: 14) {
                            Label("A calm 12-minute practice", systemImage: "clock")
                                .font(.headline)
                            Text("Each day mixes listening, retrieval, one small conversation, and a speaking try. Tamil gives you a bridge; English keeps the gist clear.")
                                .font(.subheadline)
                                .foregroundStyle(PesaColors.slate)
                                .fixedSize(horizontal: false, vertical: true)
                            Divider()
                            VStack(alignment: .leading, spacing: 10) {
                                FeatureRow(icon: "ear.fill", title: "Listen first", detail: "Hear the phrase before the answer appears.")
                                FeatureRow(icon: "arrow.triangle.2.circlepath", title: "Recall for real", detail: "Weak patterns return in a later day.")
                                FeatureRow(icon: "bubble.left.and.bubble.right.fill", title: "Use it in context", detail: "Choose a reply, then try the line aloud.")
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("The 30-day target")
                            .font(.headline)
                            .foregroundStyle(PesaColors.ink)
                        Text("Build a repeatable way to catch anchors, tense clues, and intent in familiar everyday speech. This is a practice target, not a promise of fluency.")
                            .font(.subheadline)
                            .foregroundStyle(PesaColors.slate)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    PrimaryActionButton(title: "Start with Day 1", systemImage: "arrow.right") {
                        model.completeOnboarding()
                    }
                    .padding(.bottom, 20)
                }
                .padding(.horizontal, 22)
            }
        }
    }
}

private struct FeatureRow: View {
    let icon: String
    let title: String
    let detail: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(PesaColors.coral)
                .frame(width: 22)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.subheadline.weight(.semibold))
                Text(detail).font(.caption).foregroundStyle(PesaColors.slate)
            }
        }
    }
}
