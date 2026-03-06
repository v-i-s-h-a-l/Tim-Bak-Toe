import SwiftUI

struct GameView: View {
    @Bindable var viewModel: GameViewModel
    let onHome: () -> Void

    @State private var boardAppeared = false

    var body: some View {
        GeometryReader { geometry in
            let boardSize = LayoutConstants.boardSize(for: geometry.size.width)
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
                if viewModel.showWinnerView {
                    WinnerOverlayView(
                        winner: viewModel.engine.state.winner,
                        onRestart: { viewModel.restart() },
                        onHome: onHome
                    )
                }
            }
        }
        .onAppear {
            viewModel.startGame(mode: viewModel.gameMode)
            withAnimation(.spring(duration: 0.6, bounce: 0.3)) {
                boardAppeared = true
            }
        }
    }
}
