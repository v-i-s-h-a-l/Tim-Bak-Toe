import SwiftUI

protocol ThemeProvider: Sendable {
    var backgroundColor: Color { get }
    var overlayBackdropColor: Color { get }

    func pieceBottomLayer(state: PieceViewState, size: CGSize) -> AnyView
    func pieceUpperLayer(state: PieceViewState, size: CGSize, style: PieceStyle) -> AnyView
    func winParticles(winner: Player?) -> AnyView

    func dragSquishScale() -> CGSize
    func dragRotation(velocityX: CGFloat) -> Double
    func placeBounceKeyframes() -> [CGSize]
    func wonAnimation() -> Animation
    func wonBounceDelay(pieceIndex: Int) -> Double
    func wonBounceOffset(for size: CGSize) -> CGFloat
}
