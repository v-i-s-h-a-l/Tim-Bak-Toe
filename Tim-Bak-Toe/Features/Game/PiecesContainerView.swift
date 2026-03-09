import SwiftUI

struct PiecesContainerView: View {
    let pieceSize: CGSize
    let pieces: [PieceUIState]
    @Bindable var viewModel: GameViewModel

    private var containerZIndex: Double {
        pieces.contains(where: { $0.viewState == .dragged })
            ? LayoutConstants.ZIndex.playerPieceDragged
            : LayoutConstants.ZIndex.playerPiecePlaced
    }

    var body: some View {
        let spacing = pieceSize.height / 5.0

        HStack(spacing: spacing) {
            ForEach(Array(pieces.enumerated()), id: \.element.id) { index, piece in
                PieceView(pieceId: piece.id, style: piece.style, size: pieceSize, pieceIndex: index, viewModel: viewModel)
                    .setAccessibilityIdentifier(element: piece.owner == .x ? .hostPiece(index) : .peerPiece(index))
                    .zIndex(piece.zIndex)
            }
        }
        .zIndex(containerZIndex)
    }
}
