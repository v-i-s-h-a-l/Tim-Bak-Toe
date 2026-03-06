import SwiftUI

enum Screen: Equatable {
    case onboarding
    case home
    case game(GameMode)
}

struct ContentView: View {
    @State private var currentScreen: Screen = .home
    @State private var settingsViewModel = SettingsViewModel()
    @State private var gameViewModel: GameViewModel?
    @State private var showSettings = false

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationStack {
            Group {
                switch currentScreen {
                case .onboarding:
                    OnboardingScreen {
                        withAnimation(.spring(duration: 0.5, bounce: 0.2)) {
                            startGame(mode: .localMultiplayer)
                        }
                    }
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                case .home:
                    HomeScreen(
                        onPlay: { mode in
                            withAnimation(.spring(duration: 0.5, bounce: 0.2)) {
                                startGame(mode: mode)
                            }
                        },
                        onSettings: {
                            showSettings = true
                        }
                    )
                    .transition(.move(edge: .leading).combined(with: .opacity))
                case .game:
                    if let vm = gameViewModel {
                        GameView(viewModel: vm, onHome: {
                            withAnimation(.spring(duration: 0.4, bounce: 0.2)) {
                                gameViewModel = nil
                                currentScreen = .home
                            }
                        })
                        .transition(.scale(scale: 0.9).combined(with: .opacity))
                    }
                }
            }
            .navigationDestination(isPresented: $showSettings) {
                SettingsScreen(settingsViewModel: settingsViewModel) {
                    showSettings = false
                }
                .navigationBarBackButtonHidden()
                .enableSwipeBack()
            }
            .toolbar(.hidden, for: .navigationBar)
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
