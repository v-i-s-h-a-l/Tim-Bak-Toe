import SwiftUI

struct PieceView: View {
    let pieceId: UUID
    let style: PieceStyle
    let size: CGSize
    @Bindable var viewModel: GameViewModel

    @State private var hasAppeared = false

    private var state: PieceUIState? {
        viewModel.pieceStates[pieceId]
    }

    var body: some View {
        let viewState = state?.viewState ?? .disabled
        let relativeOffset = state?.relativeOffset ?? .zero
        let scale = state?.scale ?? 1.0
        ZStack {
            viewState.bottomShadowLayer(pieceSize: size)
            viewState.upperFillLayer(pieceSize: size)
            style.overlay(forSize: size)
        }
        .frame(width: size.width, height: size.height)
        .scaleEffect(hasAppeared ? scale : 0.01)
        .offset(relativeOffset)
        .allowsHitTesting(viewState.allowsHitTesting)
        .onGeometryChange(for: CGPoint.self) { proxy in
            proxy.frame(in: .global).center
        } action: { center in
            if state?.occupiedCellId == nil && state?.viewState != .dragged {
                viewModel.pieceStates[pieceId]?.centerGlobal = center
            }
        }
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
        .onAppear {
            let delay = Double.random(in: 0...0.2)
            withAnimation(.spring(duration: 0.5, bounce: 0.5).delay(delay)) {
                hasAppeared = true
            }
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
