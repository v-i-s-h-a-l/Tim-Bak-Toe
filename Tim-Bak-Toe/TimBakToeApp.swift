import SwiftUI

@main
struct TimBakToeApp: App {
    init() {
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .pad {
            UISegmentedControl.appearance().setTitleTextAttributes(
                [.font: UIFont.systemFont(ofSize: 20, weight: .medium)],
                for: .normal
            )
        }
        #endif
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        #if os(macOS)
        .defaultSize(width: 500, height: 750)
        .windowResizability(.contentSize)
        #endif
    }
}
