import SwiftUI

struct PieceView: View {
    let pieceId: UUID
    let style: PieceStyle
    let size: CGSize
    let pieceIndex: Int
    @Bindable var viewModel: GameViewModel

    @Environment(\.themeProvider) private var theme

    @State private var hasAppeared = false
    @State private var squishScale: CGSize = CGSize(width: 1, height: 1)
    @State private var bounceOffset: CGFloat = 0
    @State private var rotationAngle: Double = 0

    private var state: PieceUIState? {
        viewModel.pieceStates[pieceId]
    }

    var body: some View {
        let viewState = state?.viewState ?? .disabled
        let relativeOffset = state?.relativeOffset ?? .zero
        let scale = state?.scale ?? 1.0
        ZStack {
            theme.pieceBottomLayer(state: viewState, size: size)
            theme.pieceUpperLayer(state: viewState, size: size, style: style)
        }
        .frame(width: size.width, height: size.height)
        .scaleEffect(hasAppeared ? scale : 0.01)
        .scaleEffect(x: squishScale.width, y: squishScale.height)
        .rotationEffect(.degrees(rotationAngle))
        .offset(relativeOffset)
        .offset(y: bounceOffset)
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
                    // Lean in direction of movement — velocity-based tilt
                    let targetRotation = theme.dragRotation(velocityX: drag.velocity.width)
                    withAnimation(.spring(duration: 0.12, bounce: 0.35)) {
                        rotationAngle = targetRotation
                    }
                }
                .onEnded { drag in
                    viewModel.pieceDragEnded(pieceId, drag: drag)
                    // Spring rotation back to upright
                    withAnimation(.spring(duration: 0.5, bounce: 0.65)) {
                        rotationAngle = 0
                    }
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
        switch newState {

        case .dragged:
            withAnimation(.default) {
                viewModel.pieceStates[pieceId]?.scale = newState.scale
            }
            let squish = theme.dragSquishScale()
            let squishIsDistorted = squish.width != 1 || squish.height != 1
            if squishIsDistorted {
                // Continuous jelly wobble while held: oscillates between neutral and squish
                withAnimation(.spring(duration: 0.32, bounce: 0.55).repeatForever(autoreverses: true)) {
                    squishScale = squish
                }
            }

        case .placed:
            withAnimation(.default) {
                viewModel.pieceStates[pieceId]?.scale = newState.scale
            }
            let keyframes = theme.placeBounceKeyframes()
            if !keyframes.isEmpty {
                // Snap to impact scale quickly (cancels the drag wobble animation)
                withAnimation(.spring(duration: 0.07, bounce: 0)) {
                    squishScale = keyframes[0]
                }
                // After the snap, spring back with high-bounce jelly physics
                withAnimation(.spring(duration: 0.62, bounce: 0.82).delay(0.07)) {
                    squishScale = CGSize(width: 1, height: 1)
                }
            } else {
                withAnimation(.spring(duration: 0.3, bounce: 0.4)) {
                    squishScale = CGSize(width: 1, height: 1)
                }
            }

        case .won:
            let delay = theme.wonBounceDelay(pieceIndex: pieceIndex)
            withAnimation(theme.wonAnimation().delay(delay)) {
                viewModel.pieceStates[pieceId]?.scale = newState.scale
            }
            let offset = theme.wonBounceOffset(for: size)
            if offset != 0 {
                withAnimation(.spring(duration: 0.4, bounce: 0.7).repeatForever(autoreverses: true).delay(delay)) {
                    bounceOffset = offset
                }
            }
            // Ensure squish is clean for win state
            withAnimation(.spring(duration: 0.3, bounce: 0.5)) {
                squishScale = CGSize(width: 1, height: 1)
                rotationAngle = 0
            }

        default:
            withAnimation(.spring(duration: 0.3, bounce: 0.4)) {
                squishScale = CGSize(width: 1, height: 1)
                rotationAngle = 0
            }
            withAnimation(.default) {
                viewModel.pieceStates[pieceId]?.scale = newState.scale
            }
        }
    }
}
