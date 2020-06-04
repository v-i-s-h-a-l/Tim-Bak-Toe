//
//  PieceViewModel.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 22/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

class PieceViewModel: ObservableObject, Identifiable {
    let id = UUID()
    private var occupiedCellID: UUID?
    let style: PieceStyle
    let teamId: UUID

    init(with style: PieceStyle) {
        self.style = style
        self.teamId = (style == .X ? hostId : peerId)
    }

    @Published var relativeOffset: CGSize = .zero
    @Published var disabled: Bool = false
    @Published var zIndex: Double = ZIndex.playerPiecePlaced
    @Published var shadowRadius: CGFloat = 2.0

    /// publishes team id, piece id and optional occeupied cell id
    var dragStartedPublisher = PassthroughSubject<(UUID, UUID, UUID?), Never>()

    /// publishes team id, drag end location, piece id and optional occeupied cell id
    var draggedEndedPublisher = PassthroughSubject<(UUID, CGPoint, UUID, UUID?), Never>()

    private var isDragStarted: Bool = false {
        didSet {
            withAnimation {
                zIndex = isDragStarted ? ZIndex.playerPieceDragged : ZIndex.playerPiecePlaced
                shadowRadius = isDragStarted ? 4.0 : 2.0
            }
        }
    }
    private var cancellables: Set<AnyCancellable> = []

    private var dragAmount: CGSize = .zero
    private var currentOffset: CGSize = .zero

    private var centerGlobal: CGPoint = .zero

    func onAppear(_ proxy: GeometryProxy) {
        self.centerGlobal = proxy.frame(in: .global).center
    }

    // MARK: - functions to be called by view -
    
    func onDragChanged(_ drag: DragGesture.Value) {
        // prevents from dragging multiple items
        guard !self.disabled else { return }
        if !isDragStarted {
            self.isDragStarted = true
            self.dragStartedPublisher
                .send((teamId, id, occupiedCellID))
        } else {
            self.dragAmount = CGSize(width: drag.translation.width, height: drag.translation.height)
                self.relativeOffset = dragAmount + currentOffset
        }
    }
    
    func onDragEnded(_ drag: DragGesture.Value) {
        // prevents from dragging multiple items
        guard !self.disabled else { return }
        isDragStarted = false

        Just(false)
            .delay(for: .seconds(0.5), scheduler: RunLoop.current)
            .sink { _ in
                self.isDragStarted = false }
        .store(in: &cancellables)

        draggedEndedPublisher
            .send((teamId, drag.location, id, occupiedCellID))
    }

    // MARK: - functions called by game vm to provide publishers -

    func subscribeToDragStart(_ publisher: PassthroughSubject<(UUID, UUID), Never>) {
        publisher
            .filter { teamId, _ in
                teamId == self.teamId
            }
            .sink { (_, draggedPieceId) in
            self.disabled = self.id != draggedPieceId
        }
        .store(in: &cancellables)
    }

    fileprivate func moveToUpdatedOffset() {
        dragAmount = .zero
        withAnimation {
            relativeOffset = currentOffset
        }
    }
    
    func subscribeToDragEnd(_ publisher: PassthroughSubject<(UUID, UUID), Never>) {
        publisher
            .filter { teamId, _ in
                teamId == self.teamId
            }
            // waits for drop success calculations (if any)
            // if successful drop is there then currentOffset gets updated accordingly
            .delay(for: .milliseconds(20), scheduler: RunLoop.current)
            .sink { _, _ in
                self.moveToUpdatedOffset()
        }
        .store(in: &cancellables)
        
        publisher
            .filter { teamId, _ in
                teamId == self.teamId
        }
        .sink { _ in
            self.disabled = false
        }
        .store(in: &cancellables)
    }
    
    func subscribeToNewOccupancy(_ publisher: PassthroughSubject<(UUID, CGPoint, UUID, UUID), Never>) {
        // updates the dragged piece
        publisher
            .filter { (_, _, pieceId, _) in
                pieceId == self.id
            }
        .sink { (_, newCellCenter, _, newCellId) in
            self.occupiedCellID = newCellId
            self.currentOffset = newCellCenter - self.centerGlobal
        }
        .store(in: &cancellables)

        // pauses drag for pieces in the same team
        publisher
            .map { (teamId, _, _, _) in
                teamId == self.teamId }
        .assign(to: \.disabled, on: self)
        .store(in: &cancellables)
    }

    func subscribeToSuccessfulRefilling(_ publisher: PassthroughSubject<UUID, Never>) {
        // enables the pieces of the team id received
        publisher
                .map { teamId in
                    // if self team id is refilled then the pieces are enabled
                    // if opponent's timer is refilled then self is disabled
                    !(teamId == self.teamId) }
            .assign(to: \.disabled, on: self)
            .store(in: &cancellables)

        // force drag end for any piece that the opponent had been dragging
        publisher
                .filter { teamId in
                    teamId != self.teamId}
                .sink { teamID in
                    self.isDragStarted = false
                    self.moveToUpdatedOffset()
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
        withAnimation {
            self.currentOffset = .zero
            self.dragAmount = .zero
            self.disabled = false
            self.isDragStarted = false
            self.occupiedCellID = nil
            self.relativeOffset = .zero
        }
    }
}
