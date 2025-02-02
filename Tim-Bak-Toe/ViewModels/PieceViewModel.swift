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
    
    @Published var relativeOffset: CGSize = .zero  // dynamic relative offset to original location
    @Published var pieceState: PieceViewState = .placed
    @Published var zIndex: Double = 0.0
    
    /// publishes team id, piece id and optional occeupied cell id
    var dragStartedPublisher = PassthroughSubject<(UUID, UUID, UUID?), Never>()
    
    /// publishes team id, drag end location, piece id and optional occeupied cell id
    var draggedEndedPublisher = PassthroughSubject<(UUID, CGPoint, UUID, UUID?), Never>()
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var dragStartOffset: CGSize = .zero  // how much far from the center of a piece had the drag started
    private var dragAmount: CGSize = .zero
    private var currentOffset: CGSize = .zero  // last placed location offset relative to original
    
    private var centerGlobal: CGPoint = .zero
    
    func onAppear(_ proxy: GeometryProxy) {
        self.centerGlobal = proxy.frame(in: .global).center
    }
    
    // MARK: - functions to be called by view -
    
    func onDragChanged(_ drag: DragGesture.Value) {
        // prevents from dragging multiple items
        guard self.pieceState != .disabled else { return }
        if !(self.pieceState == .dragged) {
            Sound.pop.play()
            self.dragStartedPublisher
                .send((teamId, id, occupiedCellID))
            
            dragStartOffset = CGSize(width: drag.startLocation.x - (currentOffset.width + centerGlobal.x), height: drag.startLocation.y - (currentOffset.height + centerGlobal.y))
        }
        withAnimation(.easeOutQuart) {
            dragAmount = CGSize(width: drag.translation.width, height: drag.translation.height)
            relativeOffset = dragAmount + currentOffset + dragStartOffset
        }
    }
    
    func onDragEnded(_ drag: DragGesture.Value) {
        // prevents from dragging multiple items
        guard self.pieceState != .disabled else { return }
        
        draggedEndedPublisher
            .send((teamId, drag.location, id, occupiedCellID))
    }
    
    // MARK: - functions called by game vm to provide publishers -
    
    func subscribeToGameStart(_ publisher: PassthroughSubject<UUID, Never>) {
        publisher
        .filter { teamId in teamId != self.teamId }
        .sink { _ in self.pieceState = .disabled }
        .store(in: &cancellables)
    }
    
    func subscribeToDragStart(_ publisher: PassthroughSubject<(UUID, UUID), Never>) {
        publisher
            .filter { teamId, _ in teamId == self.teamId }
            .sink { (_, draggedPieceId) in
                withAnimation { self.pieceState = self.id == draggedPieceId ? .dragged : .disabled } }
            .store(in: &cancellables)
    }
    
    fileprivate func moveToUpdatedOffset() {
        dragAmount = .zero
        dragStartOffset = .zero
        withAnimation { relativeOffset = currentOffset }
    }
    
    func subscribeToDragEnd(_ publisher: PassthroughSubject<(UUID, UUID), Never>) {
        publisher
            .filter { teamId, _ in teamId == self.teamId }
            // waits for drop success calculations (if any)
            // if successful drop is there then currentOffset gets updated accordingly
            .delay(for: .milliseconds(20), scheduler: RunLoop.main)
            .sink { _, _ in self.moveToUpdatedOffset() }
            .store(in: &cancellables)
        
        publisher
            .filter { teamId, _ in teamId == self.teamId }
            .sink { _ in self.pieceState = .placed }
            .store(in: &cancellables)
    }
    
    func subscribeToNewOccupancy(_ publisher: PassthroughSubject<(UUID, CGPoint, UUID, UUID), Never>) {
        // updates the dragged piece
        publisher
            .filter { (_, _, pieceId, _) in
                pieceId == self.id }
            .sink { (_, newCellCenter, _, newCellId) in
                Sound.place.play()
                self.occupiedCellID = newCellId
                self.currentOffset = newCellCenter - self.centerGlobal }
            .store(in: &cancellables)
        
        // pauses drag for pieces in the same team
        publisher
            .map { (teamId, _, _, _) in
                return (teamId == self.teamId) ? PieceViewState.disabled : PieceViewState.placed }
            .assign(to: \.pieceState, on: self)
            .store(in: &cancellables)
    }
    
    func subscribeToTimerEmptied(_ publisher: PassthroughSubject<UUID, Never>) {
        // enables the pieces of the team id received
        publisher
            .map { teamId in
                return (teamId != self.teamId) ? PieceViewState.placed : PieceViewState.disabled }
            .assign(to: \.pieceState, on: self)
            .store(in: &cancellables)
        
        // force drag end for any piece that the opponent had been dragging
        publisher
            .filter { $0 == self.teamId }
            .sink { teamID in
                self.pieceState = .disabled
                self.moveToUpdatedOffset() }
            .store(in: &cancellables)
    }
    
    func subscribeToRestart(_ publisher: PassthroughSubject<Void, Never>) {
        publisher
            .sink { _ in self.reset() }
            .store(in: &cancellables)
    }
    
    private func reset() {
        withAnimation {
            self.currentOffset = .zero
            self.dragAmount = .zero
            self.dragStartOffset = .zero
            self.relativeOffset = .zero
            self.pieceState = .placed
            self.occupiedCellID = nil
        }
    }
    
    // MARK: - Winning -
    
    func subscribeToWin(_ publisher: PassthroughSubject<UUID, Never>) {
        publisher
            .delay(for: .milliseconds(50), scheduler: RunLoop.main)
            .sink { teamId in
                self.pieceState = (teamId == self.teamId) ? .won : .lost }
            .store(in: &cancellables)
    }
}
