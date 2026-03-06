import SwiftUI

enum Screen: Equatable {
    case onboarding
    case home
    case settings
    case game(GameMode)
}

struct ContentView: View {
    @State private var currentScreen: Screen = .home
    @State private var settingsViewModel = SettingsViewModel()
    @State private var gameViewModel: GameViewModel?

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Group {
            switch currentScreen {
            case .onboarding:
                OnboardingScreen {
                    startGame(mode: .localMultiplayer)
                }
            case .home:
                HomeScreen(
                    onPlay: { mode in startGame(mode: mode) },
                    onSettings: { currentScreen = .settings }
                )
            case .settings:
                SettingsScreen(settingsViewModel: settingsViewModel) {
                    currentScreen = .home
                }
            case .game:
                if let vm = gameViewModel {
                    GameView(viewModel: vm, onHome: {
                        gameViewModel = nil
                        currentScreen = .home
                    })
                }
            }
        }
        .preferredColorScheme(settingsViewModel.preferredColorScheme)
        .onAppear {
            let isFirstLaunch = !UserDefaults.standard.bool(forKey: "AlreadyLaunched")
            currentScreen = isFirstLaunch ? .onboarding : .home
            UserDefaults.standard.set(true, forKey: "AlreadyLaunched")
        }
    }

    private func startGame(mode: GameMode) {
        let vm = GameViewModel()
        vm.gameMode = mode
        gameViewModel = vm
        currentScreen = .game(mode)
    }
}
