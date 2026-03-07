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
    @State private var multiplayerAdapter: MultiplayerAdapter?

    @Environment(\.colorScheme) var colorScheme

    private var gameCenterManager: GameCenterManager { .shared }

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
                            if mode == .onlineMultiplayer {
                                startOnlineGame()
                            } else {
                                withAnimation(.spring(duration: 0.5, bounce: 0.2)) {
                                    startGame(mode: mode)
                                }
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
                            goHome()
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
            #if os(iOS)
            .toolbar(.hidden, for: .navigationBar)
            #endif
        }
        #if os(macOS)
        .frame(minWidth: 400, idealWidth: 500, maxWidth: 600,
               minHeight: 600, idealHeight: 750, maxHeight: 900)
        #endif
        .preferredColorScheme(settingsViewModel.preferredColorScheme)
        .onAppear {
            let isFirstLaunch = !UserDefaults.standard.bool(forKey: "AlreadyLaunched")
            currentScreen = isFirstLaunch ? .onboarding : .home
            UserDefaults.standard.set(true, forKey: "AlreadyLaunched")
            gameCenterManager.authenticate()
        }
    }

    private func startGame(mode: GameMode) {
        let vm = GameViewModel()
        vm.gameMode = mode
        gameViewModel = vm
        currentScreen = .game(mode)
    }

    private func startOnlineGame() {
        guard gameCenterManager.isAuthenticated else {
            gameCenterManager.authenticate()
            return
        }

        let vm = GameViewModel()
        vm.gameMode = .onlineMultiplayer
        gameViewModel = vm

        let adapter = MultiplayerAdapter(gameCenterManager: gameCenterManager)
        adapter.viewModel = vm
        vm.multiplayerAdapter = adapter
        self.multiplayerAdapter = adapter

        gameCenterManager.onMatchReady = {
            withAnimation(.spring(duration: 0.5, bounce: 0.2)) {
                self.currentScreen = .game(.onlineMultiplayer)
            }
        }

        gameCenterManager.onMatchError = { errorMessage in
            self.gameViewModel = nil
            self.multiplayerAdapter = nil
        }

        gameCenterManager.findMatch()
    }

    private func goHome() {
        if gameViewModel?.isOnline == true {
            multiplayerAdapter?.sendResigned()
            multiplayerAdapter = nil
        }
        withAnimation(.spring(duration: 0.4, bounce: 0.2)) {
            gameViewModel = nil
            currentScreen = .home
        }
    }
}
