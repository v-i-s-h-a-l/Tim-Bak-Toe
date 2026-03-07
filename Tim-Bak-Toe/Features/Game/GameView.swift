import SwiftUI

struct GameView: View {
    @Bindable var viewModel: GameViewModel
    let onHome: () -> Void

    @State private var boardAppeared = false
    @State private var rematchRequested = false
    @State private var showCountdown = true

    var body: some View {
        GeometryReader { geometry in
            let boardSize = LayoutConstants.boardSize(for: geometry.size)
            let pieceSize = LayoutConstants.pieceSize(for: boardSize)
            let timerHeight = pieceSize.height / 8.0
            let padding = pieceSize.height / 3.0

            ZStack {
                Theme.Col.gameBackground
                    .ignoresSafeArea()

                VStack {
                    Spacer()

                    PiecesContainerView(
                        pieceSize: pieceSize,
                        pieces: viewModel.oPieceStates(),
                        viewModel: viewModel
                    )
                    .transition(.move(edge: .top).combined(with: .opacity))

                    Spacer()

                    TimerBarView(timer: viewModel.oTimer, style: .O, isRightEdged: true)
                        .frame(height: timerHeight)
                        .padding(.horizontal, padding)

                    Spacer()

                    BoardView(boardSize: boardSize, viewModel: viewModel)
                        .scaleEffect(boardAppeared ? 1 : 0.8)
                        .opacity(boardAppeared ? 1 : 0)

                    Spacer()

                    TimerBarView(timer: viewModel.xTimer, style: .X, isRightEdged: false)
                        .frame(height: timerHeight)
                        .padding(.horizontal, padding)

                    Spacer()

                    PiecesContainerView(
                        pieceSize: pieceSize,
                        pieces: viewModel.xPieceStates(),
                        viewModel: viewModel
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))

                    Spacer()
                }
            }
            .overlay {
                if showCountdown {
                    CountdownOverlayView {
                        showCountdown = false
                        viewModel.beginAfterCountdown()
                    }
                }
            }
            .overlay {
                if viewModel.showWinnerView {
                    WinnerOverlayView(
                        winner: viewModel.engine.state.winner,
                        isOnline: viewModel.isOnline,
                        isDisconnected: viewModel.disconnectedRemotely,
                        rematchRequested: rematchRequested,
                        onRestart: {
                            if viewModel.isOnline {
                                rematchRequested = true
                                viewModel.multiplayerAdapter?.requestRematch()
                            } else {
                                showCountdown = true
                                viewModel.restart()
                            }
                        },
                        onHome: onHome
                    )
                }
            }
        }
        .onAppear {
            setupMultiplayerCallbacks()
            viewModel.prepareGame(mode: viewModel.gameMode)
            withAnimation(.spring(duration: 0.6, bounce: 0.3)) {
                boardAppeared = true
            }
        }
    }

    private func setupMultiplayerCallbacks() {
        guard let adapter = viewModel.multiplayerAdapter else { return }

        adapter.onRematchRequested = { [self] in
            // Remote player requested rematch — if we already requested, both agreed
            if rematchRequested {
                rematchRequested = false
                showCountdown = true
                viewModel.restart()
            }
            // Otherwise the remote request is stored in the adapter;
            // when local taps Rematch, adapter.requestRematch() will trigger it
        }

        adapter.onRematchAccepted = { [self] in
            rematchRequested = false
            showCountdown = true
            viewModel.restart()
        }

        adapter.onOpponentResigned = {
            viewModel.handleRemoteDisconnection()
        }

        adapter.onOpponentDisconnected = {
            viewModel.handleRemoteDisconnection()
        }
    }
}
