import SwiftUI

@main
@MainActor
struct PesaHindiApp: App {
    @StateObject private var model = AppModel()

    var body: some Scene {
        WindowGroup {
            AppShellView()
                .environmentObject(model)
                .environmentObject(model.speechService)
                .environmentObject(model.speechChecker)
        }
    }
}
