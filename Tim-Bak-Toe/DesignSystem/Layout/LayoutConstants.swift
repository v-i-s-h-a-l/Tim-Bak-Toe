import SwiftUI

enum LayoutConstants {
    static var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    static var boardWidthMultiplier: CGFloat { isPad ? 0.65 : 0.85 }
    static var cellPadding: CGFloat { isPad ? 15 : 10 }
    static var screenEdgePadding: CGFloat { isPad ? 30 : 15 }

    enum ZIndex {
        static let board = 0.0
        static let playerPiecePlaced = 1.0
        static let playerPieceDragged = 2.0
    }

    static func boardSize(for geometryWidth: CGFloat) -> CGSize {
        let side = geometryWidth * boardWidthMultiplier
        return CGSize(width: side, height: side)
    }

    static func pieceSize(for boardSize: CGSize) -> CGSize {
        let side = boardSize.width / 3.0 - (2.0 * cellPadding)
        return CGSize(width: side, height: side)
    }
}
