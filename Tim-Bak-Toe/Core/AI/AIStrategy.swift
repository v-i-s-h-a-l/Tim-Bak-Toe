import Foundation

protocol AIStrategy: Sendable {
    func selectMove(engine: GameEngine, player: Player) async -> Move?
}
