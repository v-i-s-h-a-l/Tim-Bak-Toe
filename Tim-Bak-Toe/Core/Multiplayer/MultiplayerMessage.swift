import Foundation

enum MultiplayerMessage: Codable, Sendable {
    case move(pieceIndex: Int, from: BoardPosition?, to: BoardPosition)
    case wasteTurn
    case rematchRequest
    case rematchAccepted
    case resigned

    func encoded() -> Data? {
        try? JSONEncoder().encode(self)
    }

    static func decoded(from data: Data) -> MultiplayerMessage? {
        try? JSONDecoder().decode(MultiplayerMessage.self, from: data)
    }
}
