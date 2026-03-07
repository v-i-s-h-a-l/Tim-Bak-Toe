import SwiftUI

@main
struct TimBakToeApp: App {
    init() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            UISegmentedControl.appearance().setTitleTextAttributes(
                [.font: UIFont.systemFont(ofSize: 20, weight: .medium)],
                for: .normal
            )
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
