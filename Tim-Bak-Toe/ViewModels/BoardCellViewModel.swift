//
//  BoardCellViewModel.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 22/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

class BoardCellViewModel: ObservableObject, Identifiable {

    let id = UUID()
    var pieceId: UUID?
    var teamId: UUID?
    var indexPath: String
    
    init(with row: Int, column: Int) {
        self.indexPath = "\(row),\(column)"
    }

    var newOccupancyPublisher = PassthroughSubject<(UUID, CGPoint, UUID, UUID, UUID?), Never>()

    private var frameGlobal: CGRect!
    private lazy var centerGlobal: CGPoint = frameGlobal.center

    private var cancellables = Set<AnyCancellable>()

    func onAppear(_ proxy: GeometryProxy) {
        self.frameGlobal = proxy.frame(in: .global)
    }

    func subscribeToDragEnded(_ publisher: PassthroughSubject<(UUID, CGPoint, UUID, UUID?), Never>) {
        // calculates only successful drops
        // rest will be handled in
        publisher
            .filter({ (teamId, point, pieceId, originCellId) in
                if self.frameGlobal.contains(point) && self.pieceId == nil {
                    return true
                } else {
                    return false
                }
            }).sink(receiveValue: { (teamId, _, pieceId, originCellId) in
                self.pieceId = pieceId
                self.teamId = teamId
                self.newOccupancyPublisher.send((teamId, self.centerGlobal, pieceId, self.id, originCellId))
            })
            .store(in: &cancellables)
    }
    
    func subscribeToNewOccupancy(_ publisher: PassthroughSubject<(UUID, UUID?), Never>) {
        publisher
            .filter { $1 != nil }       // freshly occupied
            .sink { (pieceId, oldCellId) in
            if self.pieceId == pieceId && self.id == oldCellId {
                self.pieceId = nil
                self.teamId = nil
            }
        }
        .store(in: &cancellables)
    }

    func subscribeToRestart(_ publisher: PassthroughSubject<Void, Never>) {
        publisher.sink { _ in
            self.reset()
        }
        .store(in: &cancellables)
    }

    private func reset() {
        pieceId = nil
        teamId = nil
    }
}
