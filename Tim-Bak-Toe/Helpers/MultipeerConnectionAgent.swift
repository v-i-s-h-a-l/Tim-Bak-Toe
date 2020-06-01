//
//  MultipeerConnectionAgent.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 27/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import Combine
import Foundation
import MultipeerConnectivity
import SwiftUI

struct PiecePositionModel: Codable {
    let teamId: UUID
    let pieceId: UUID
    let cellId: UUID
    let previousCellId: UUID?
}

class MCAgent: NSObject {

    let sourceView: UIHostingController<GameView>

    let localId: MCPeerID = .init(displayName: UIDevice.current.name)
    var newOccupancyFrompeerPublisher = PassthroughSubject<PiecePositionModel, Error>()

    private var cancellables: Set<AnyCancellable> = []

    init(sourceView: UIHostingController<GameView>) {
        self.sourceView = sourceView
        super.init()
    }
    
    private lazy var session: MCSession = {
        let session = MCSession(peer: localId, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self

        return session
    }()

    private var mcNearbyServiceAdvertiser: MCNearbyServiceAdvertiser!
    private var connectedPeerIds: [MCPeerID] = []

    func startHosting() {
        mcNearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: self.localId, discoveryInfo: nil, serviceType: "Tim-Bak-Toe")
        mcNearbyServiceAdvertiser.startAdvertisingPeer()
    }

    func joinSession() {
        let mcBrowser = MCNearbyServiceBrowser(peer: self.localId, serviceType: "Tim-Bak-Toe")
        mcBrowser.delegate = self
        mcBrowser.startBrowsingForPeers()
    }

    func subscribeToNewOccupancy(_ publisher: PassthroughSubject<(UUID, UUID, UUID, UUID?), Never>) {
        // updates the dragged piece
        publisher
        .sink { (teamId, pieceId, newCellId, previousCellId) in
            let model = PiecePositionModel(teamId: teamId, pieceId: pieceId, cellId: newCellId, previousCellId: previousCellId)
            self.processAndSendNewOccupancySignal(model)
        }
        .store(in: &cancellables)
    }
    
    private func processAndSendNewOccupancySignal(_ model: PiecePositionModel) {
        do {
            let json = try JSONEncoder().encode(model)
            try self.session.send(json, toPeers: self.connectedPeerIds, with: .reliable)
        } catch {
//            let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .default))
//            self.sourceView.present(ac, animated: true)
        }
    }
}

extension MCAgent: MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCAdvertiserAssistantDelegate {

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state.rawValue)")
//        self.delegate?.connectedDevicesChanged(manager: self, connectedDevices:
//            session.connectedPeers.map{$0.displayName})
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data)")
//        let str = String(data: data, encoding: .utf8)!
//        self.delegate?.colorChanged(manager: self, colorString: str)
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveStream")
    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        NSLog("%@", "didFinishReceivingResourceWithName")
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
        invitationHandler(true, self.session)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
    }

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        NSLog("%@", "foundPeer: \(peerID)")
        NSLog("%@", "invitePeer: \(peerID)")
        browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        NSLog("%@", "lostPeer: \(peerID)")
    }
}
