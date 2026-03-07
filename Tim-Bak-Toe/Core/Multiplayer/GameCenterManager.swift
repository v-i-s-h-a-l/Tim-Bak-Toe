import GameKit
import SwiftUI

enum MatchState: Equatable {
    case idle
    case matchmaking
    case connected
    case disconnected
    case error(String)
}

@MainActor @Observable
final class GameCenterManager: NSObject {
    static let shared = GameCenterManager()

    var isAuthenticated = false
    var matchState: MatchState = .idle
    var localRole: Player = .x

    private(set) var currentMatch: GKMatch?
    private var remotePlayerID: String?

    var onMessageReceived: ((MultiplayerMessage) -> Void)?
    var onMatchReady: (() -> Void)?
    var onMatchError: ((String) -> Void)?
    var onPlayerDisconnected: (() -> Void)?

    private override init() {
        super.init()
    }

    // MARK: - Authentication

    func authenticate() {
        GKLocalPlayer.local.authenticateHandler = { [weak self] viewController, error in
            Task { @MainActor in
                guard let self else { return }
                if let error {
                    self.isAuthenticated = false
                    print("Game Center auth error: \(error.localizedDescription)")
                    return
                }
                if let vc = viewController {
                    self.presentViewController(vc)
                    return
                }
                self.isAuthenticated = GKLocalPlayer.local.isAuthenticated
            }
        }
    }

    // MARK: - Matchmaking

    func findMatch() {
        guard isAuthenticated else {
            matchState = .error("Not signed in to Game Center")
            onMatchError?("Sign in to Game Center to play online.")
            return
        }

        matchState = .matchmaking

        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 2

        guard let matchmakerVC = GKMatchmakerViewController(matchRequest: request) else {
            matchState = .error("Failed to create matchmaker")
            return
        }
        matchmakerVC.matchmakerDelegate = self
        presentViewController(matchmakerVC)
    }

    // MARK: - Messaging

    func send(_ message: MultiplayerMessage) {
        guard let match = currentMatch, let data = message.encoded() else { return }
        do {
            try match.sendData(toAllPlayers: data, with: .reliable)
        } catch {
            print("Failed to send message: \(error.localizedDescription)")
        }
    }

    // MARK: - Disconnect

    func disconnect() {
        currentMatch?.disconnect()
        currentMatch?.delegate = nil
        currentMatch = nil
        remotePlayerID = nil
        matchState = .idle
    }

    // MARK: - Role Assignment

    private func assignRoles() {
        guard let remoteID = remotePlayerID else { return }
        let localID = GKLocalPlayer.local.gamePlayerID
        let sorted = [localID, remoteID].sorted()
        localRole = sorted[0] == localID ? .x : .o
    }

    // MARK: - Helpers

    private func presentViewController(_ viewController: UIViewController) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else { return }
        var topVC = rootVC
        while let presented = topVC.presentedViewController {
            topVC = presented
        }
        topVC.present(viewController, animated: true)
    }
}

// MARK: - GKMatchmakerViewControllerDelegate

extension GameCenterManager: GKMatchmakerViewControllerDelegate {
    nonisolated func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        Task { @MainActor in
            viewController.dismiss(animated: true)
            self.matchState = .idle
        }
    }

    nonisolated func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: any Error) {
        Task { @MainActor in
            viewController.dismiss(animated: true)
            self.matchState = .error(error.localizedDescription)
            self.onMatchError?(error.localizedDescription)
        }
    }

    nonisolated func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        let expectedCount = match.expectedPlayerCount
        let remoteID = match.players.first?.gamePlayerID
        match.delegate = self
        nonisolated(unsafe) let sendableMatch = match
        Task { @MainActor in
            viewController.dismiss(animated: true)
            self.currentMatch = sendableMatch

            if expectedCount == 0, let remoteID {
                self.remotePlayerID = remoteID
                self.assignRoles()
                self.matchState = .connected
                self.onMatchReady?()
            }
        }
    }
}

// MARK: - GKMatchDelegate

extension GameCenterManager: GKMatchDelegate {
    nonisolated func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        let expectedCount = match.expectedPlayerCount
        let remoteID = player.gamePlayerID
        Task { @MainActor in
            switch state {
            case .connected:
                if expectedCount == 0 {
                    self.remotePlayerID = remoteID
                    self.assignRoles()
                    self.matchState = .connected
                    self.onMatchReady?()
                }
            case .disconnected:
                self.matchState = .disconnected
                self.onPlayerDisconnected?()
            default:
                break
            }
        }
    }

    nonisolated func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        guard let message = MultiplayerMessage.decoded(from: data) else { return }
        Task { @MainActor in
            self.onMessageReceived?(message)
        }
    }

    nonisolated func match(_ match: GKMatch, didFailWithError error: (any Error)?) {
        Task { @MainActor in
            self.matchState = .error(error?.localizedDescription ?? "Unknown error")
            self.onMatchError?(error?.localizedDescription ?? "Match failed")
        }
    }
}
