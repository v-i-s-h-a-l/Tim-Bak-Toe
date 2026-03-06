import Foundation

struct GameEngine: Sendable {
    private(set) var board = GameBoard()
    private(set) var xPieces: [PlayerPiece]
    private(set) var oPieces: [PlayerPiece]
    private(set) var state: GameState = .waitingToStart
    private(set) var turnsWasted: Int = 0

    let maxWastedTurns = 4

    init() {
        xPieces = (0..<3).map { _ in PlayerPiece(owner: .x) }
        oPieces = (0..<3).map { _ in PlayerPiece(owner: .o) }
    }

    func pieces(for player: Player) -> [PlayerPiece] {
        switch player {
        case .x: return xPieces
        case .o: return oPieces
        }
    }

    func allPieces() -> [PlayerPiece] {
        xPieces + oPieces
    }

    mutating func startGame() {
        state = .playing(turn: .x)
    }

    func isValidMove(_ move: Move) -> Bool {
        guard case .playing(let turn) = state else { return false }

        let playerPieces = pieces(for: turn)
        guard let piece = playerPieces.first(where: { $0.id == move.pieceId }) else { return false }
        guard piece.owner == turn else { return false }
        guard board.isEmpty(at: move.to) else { return false }

        if let from = move.from {
            guard piece.boardPosition == from else { return false }
        } else {
            guard piece.boardPosition == nil else { return false }
        }

        return true
    }

    mutating func executeMove(_ move: Move) -> Bool {
        guard isValidMove(move) else { return false }
        guard let turn = state.currentTurn else { return false }

        if let from = move.from {
            board.remove(pieceId: move.pieceId)
            updatePiecePosition(move.pieceId, owner: turn, from: from, to: move.to)
        } else {
            updatePiecePosition(move.pieceId, owner: turn, from: nil, to: move.to)
        }

        board.place(pieceId: move.pieceId, at: move.to)
        turnsWasted = 0

        let playerPositions = board.positions(for: pieces(for: turn).map(\.id))
        if WinChecker.checkWin(positions: playerPositions) {
            state = .won(turn)
            return true
        }

        state = .playing(turn: turn.opponent)
        return true
    }

    private mutating func updatePiecePosition(_ pieceId: UUID, owner: Player, from: BoardPosition?, to: BoardPosition) {
        switch owner {
        case .x:
            if let idx = xPieces.firstIndex(where: { $0.id == pieceId }) {
                xPieces[idx].boardPosition = to
            }
        case .o:
            if let idx = oPieces.firstIndex(where: { $0.id == pieceId }) {
                oPieces[idx].boardPosition = to
            }
        }
    }

    mutating func wasteTurn() {
        guard case .playing(let turn) = state else { return }
        turnsWasted += 1
        if turnsWasted >= maxWastedTurns {
            state = .draw
        } else {
            state = .playing(turn: turn.opponent)
        }
    }

    func validMoves(for player: Player) -> [Move] {
        let playerPieces = pieces(for: player)
        let emptyPositions = BoardPosition.allPositions.filter { board.isEmpty(at: $0) }
        var moves = [Move]()

        for piece in playerPieces {
            for target in emptyPositions {
                let move = Move(pieceId: piece.id, from: piece.boardPosition, to: target)
                if isValidMove(move) {
                    moves.append(move)
                }
            }
        }
        return moves
    }

    mutating func reset() {
        board.reset()
        xPieces = (0..<3).map { _ in PlayerPiece(owner: .x) }
        oPieces = (0..<3).map { _ in PlayerPiece(owner: .o) }
        state = .waitingToStart
        turnsWasted = 0
    }
}
