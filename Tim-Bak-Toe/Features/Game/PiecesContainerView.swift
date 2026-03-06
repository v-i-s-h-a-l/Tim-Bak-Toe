import SwiftUI

struct PiecesContainerView: View {
    let pieceSize: CGSize
    let pieces: [PieceUIState]
    @Bindable var viewModel: GameViewModel

    @State private var containerZIndex: Double = LayoutConstants.ZIndex.playerPiecePlaced

    var body: some View {
        let spacing = pieceSize.height / 5.0

        HStack(spacing: spacing) {
            ForEach(pieces) { piece in
                let index = pieces.firstIndex(where: { $0.id == piece.id }) ?? 0
                PieceView(pieceId: piece.id, style: piece.style, size: pieceSize, viewModel: viewModel)
                    .setAccessibilityIdentifier(element: piece.owner == .x ? .hostPiece(index) : .peerPiece(index))
            }
        }
        .zIndex(containerZIndex)
    }
}
