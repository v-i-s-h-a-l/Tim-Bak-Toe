import SwiftUI

enum PieceViewState: Equatable {
    case disabled
    case dragged
    case placed
    case won
    case lost

    var scale: CGFloat {
        switch self {
        case .disabled, .placed, .lost: return 1
        case .dragged, .won: return 1.1
        }
    }

    var pieceColor: Color {
        Theme.Col.piece
    }

    var pieceStrokeColor: LinearGradient {
        switch self {
        case .disabled: return LinearGradient(Theme.Col.piece, Theme.Col.piece)
        case .placed, .won, .lost: return LinearGradient(Theme.Col.lightSource, Theme.Col.shadowCasted)
        case .dragged: return LinearGradient(Theme.Col.lightSource, Theme.Col.boardCell, Theme.Col.boardCell)
        }
    }

    var lightSourceShadowColor: Color {
        switch self {
        case .disabled, .dragged, .won, .lost: return Theme.Col.shadowCasted
        case .placed: return Theme.Col.lightSource
        }
    }

    var zIndex: Double {
        switch self {
        case .disabled, .placed, .won, .lost: return LayoutConstants.ZIndex.playerPiecePlaced
        case .dragged: return LayoutConstants.ZIndex.playerPieceDragged
        }
    }

    var allowsHitTesting: Bool {
        [Self.dragged, Self.placed].contains(self)
    }

    func shadowCastedRadius(for pieceSize: CGSize) -> CGFloat {
        switch self {
        case .disabled, .won, .lost: return 1
        case .dragged, .placed: return pieceSize.height / 40.0
        }
    }

    func shadowCastedDisplacement(for pieceSize: CGSize) -> CGFloat {
        switch self {
        case .disabled, .won, .lost: return 0
        case .dragged, .placed: return pieceSize.height / 40.0
        }
    }

    func lightSourceShadowRadius(for pieceSize: CGSize) -> CGFloat {
        switch self {
        case .disabled, .won, .lost: return 1
        case .dragged, .placed: return pieceSize.height / 40.0
        }
    }

    func lightSourceShadowDisplacement(for pieceSize: CGSize) -> CGFloat {
        switch self {
        case .disabled, .won, .lost: return 0
        case .dragged, .placed: return pieceSize.height / 40.0
        }
    }

    func bottomShadowLayer(pieceSize size: CGSize) -> some View {
        Circle()
            .fill(pieceColor)
            .shadow(color: lightSourceShadowColor, radius: lightSourceShadowRadius(for: size), x: -lightSourceShadowDisplacement(for: size), y: -lightSourceShadowDisplacement(for: size))
            .shadow(color: Theme.Col.shadowCasted, radius: shadowCastedRadius(for: size), x: shadowCastedDisplacement(for: size), y: shadowCastedDisplacement(for: size))
            .blur(radius: 1)
    }

    func upperFillLayer(pieceSize size: CGSize) -> some View {
        Group {
            Circle()
                .fill(pieceColor)
            Circle()
                .stroke(pieceStrokeColor, lineWidth: shadowCastedRadius(for: size) / 2.0)
        }
    }
}
