import SwiftUI

struct PieceUIState: Identifiable {
    let id: UUID
    let owner: Player
    let style: PieceStyle

    var relativeOffset: CGSize = .zero
    var viewState: PieceViewState = .placed
    var zIndex: Double = LayoutConstants.ZIndex.playerPiecePlaced
    var scale: CGFloat = 1.0

    // Drag tracking
    var centerGlobal: CGPoint = .zero
    var currentOffset: CGSize = .zero
    var dragStartOffset: CGSize = .zero
    var dragAmount: CGSize = .zero
    var occupiedCellId: BoardPosition?

    init(piece: PlayerPiece) {
        self.id = piece.id
        self.owner = piece.owner
        self.style = PieceStyle.from(player: piece.owner)
    }

    mutating func reset() {
        relativeOffset = .zero
        viewState = .placed
        zIndex = LayoutConstants.ZIndex.playerPiecePlaced
        scale = 1.0
        currentOffset = .zero
        dragStartOffset = .zero
        dragAmount = .zero
        occupiedCellId = nil
    }
}
