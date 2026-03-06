import SwiftUI

enum ScreenElement {
    case hostPiece(Int)
    case peerPiece(Int)
    case boardCell(Int, Int)

    var identifier: String {
        switch self {
        case .hostPiece(let index): return "HostPiece\(index)"
        case .peerPiece(let index): return "PeerPiece\(index)"
        case .boardCell(let row, let column): return "BoardCell\(row)\(column)"
        }
    }
}

extension View {
    func setAccessibilityIdentifier(element: ScreenElement) -> some View {
        self.accessibilityIdentifier(element.identifier)
    }
}
