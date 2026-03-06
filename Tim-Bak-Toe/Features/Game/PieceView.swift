import SwiftUI

struct PieceView: View {
    let pieceId: UUID
    let style: PieceStyle
    let size: CGSize
    @Bindable var viewModel: GameViewModel

    private var state: PieceUIState? {
        viewModel.pieceStates[pieceId]
    }

    var body: some View {
        let viewState = state?.viewState ?? .disabled
        let relativeOffset = state?.relativeOffset ?? .zero
        let scale = state?.scale ?? 1.0
        let zIdx = state?.zIndex ?? LayoutConstants.ZIndex.playerPiecePlaced

        ZStack {
            viewState.bottomShadowLayer(pieceSize: size)
            viewState.upperFillLayer(pieceSize: size)
            style.overlay(forSize: size)
        }
        .frame(width: size.width, height: size.height)
        .scaleEffect(scale)
        .offset(relativeOffset)
        .zIndex(zIdx)
        .allowsHitTesting(viewState.allowsHitTesting)
        .overlay(GeometryReader { proxy in
            Color.clear
                .onAppear {
                    viewModel.pieceAppeared(pieceId, proxy: proxy)
                }
        })
        .gesture(
            DragGesture(coordinateSpace: .global)
                .onChanged { drag in
                    viewModel.pieceDragChanged(pieceId, drag: drag)
                }
                .onEnded { drag in
                    viewModel.pieceDragEnded(pieceId, drag: drag)
                }
        )
        .onChange(of: viewState) { _, newState in
            handleStateChange(newState)
        }
    }

    private func handleStateChange(_ newState: PieceViewState) {
        let animation: Animation = newState == .won
            ? Animation.easeInOutBack.repeatForever(autoreverses: true)
            : .default
        withAnimation(animation) {
            viewModel.pieceStates[pieceId]?.scale = newState.scale
        }
    }
}
