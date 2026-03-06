import Foundation

struct EasyAI: AIStrategy {
    func selectMove(engine: GameEngine, player: Player) async -> Move? {
        let moves = engine.validMoves(for: player)
        return moves.randomElement()
    }
}
