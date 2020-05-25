//
//  GameViewModel.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 22/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

let hostId = UUID()
let peerId = UUID()

let userID = hostId

class GameViewModel: ObservableObject {
    
    var hostScore: Int = 0
    var peerScore: Int = 0

    lazy var hostPieces: [PieceViewModel] = generatePiecesForHost()
    lazy var peerPieces: [PieceViewModel] = generatePiecesForPeer()
    lazy var boardCellViewModels: [BoardCellViewModel] = generateBoardCellViewModels()
    
    lazy var hostShelfViewModel: ShelfViewModel = generateShelfViewModel(with: hostId)
    lazy var peerShelfViewModel: ShelfViewModel = generateShelfViewModel(with: peerId)

    private var cancellables = Set<AnyCancellable>()

    private let pieceDragStartToFellowPiecesPublisher = PassthroughSubject<(UUID, UUID), Never>()
    private let pieceDragEndToFellowPiecesPublisher = PassthroughSubject<(UUID, UUID), Never>()

    private let pieceDragStartToCellsPublisher = PassthroughSubject<UUID?, Never>()
    private let pieceDragEndToCellsPublisher = PassthroughSubject<(UUID, CGPoint, UUID, UUID?), Never>()

    private let newCellOccupiedByPiecePublisher = PassthroughSubject<(UUID, CGPoint, UUID, UUID), Never>()
    private let newCellOccupiedPublisherForOriginCell = PassthroughSubject<(UUID, UUID?), Never>()
    private let newCellOccupiedByPiecePublisherForShelf = PassthroughSubject<UUID, Never>()

    private let shelfRefillPublisher = PassthroughSubject<UUID, Never>()

    // MARK: - Host pieces -

    private func generatePiecesForHost() -> [PieceViewModel] {
        let generatedHostPieces = [PieceViewModel(with: .circle1), PieceViewModel(with: .circle1), PieceViewModel(with: .circle1)]

//        if userID == hostId {
            setupConnnectionsForDragStart(for: generatedHostPieces)
            setupConnnectionsForDragEnd(for: generatedHostPieces)
//        }
        
        return generatedHostPieces
    }

    private func setupConnnectionsForDragStart(for pieces: [PieceViewModel]) {
        // Receives information from specific piece
        pieces.forEach { $0.subscribeToDragStart(pieceDragStartToFellowPiecesPublisher) }

        // transmits info to all pieces and board cells
        pieces.forEach { pieceModel in
            pieceModel.dragStartedPublisher.sink { teamId, pieceID, cellId in
                self.pieceDragStartToFellowPiecesPublisher.send((teamId, pieceID))
            }
            .store(in: &cancellables)

            pieceModel.dragStartedPublisher.sink { _, _, cellId in
                self.pieceDragStartToCellsPublisher.send(cellId)
            }
            .store(in: &cancellables)
        }
    }

    private func setupConnnectionsForDragEnd(for pieces: [PieceViewModel]) {
        // Receive information from specific piece
        pieces.forEach {
            $0.subscribeToDragEnd(pieceDragEndToFellowPiecesPublisher)
            $0.subscribeToNewOccupancy(newCellOccupiedByPiecePublisher)
            $0.subscribeToSuccessfulRefilling(shelfRefillPublisher)
        }

        // transmits info to all pieces and board cells
        pieces.forEach { pieceModel in
            pieceModel.draggedEndedPublisher.sink { teamId, location, pieceID, cellId in
                self.pieceDragEndToFellowPiecesPublisher.send((teamId, pieceID))
            }
            .store(in: &cancellables)

            pieceModel.draggedEndedPublisher.sink { teamId, location, pieceID, cellId in
                self.pieceDragEndToCellsPublisher.send((teamId, location, pieceID, cellId))
            }
            .store(in: &cancellables)
        }
    }
        
        // MARK: - Peer pieces -

    private func generatePiecesForPeer() -> [PieceViewModel] {
        let generatedPieces = [PieceViewModel(with: .circle2), PieceViewModel(with: .circle2), PieceViewModel(with: .circle2)]

//        if userID == peerId {
            setupConnnectionsForDragStart(for: generatedPieces)
            setupConnnectionsForDragEnd(for: generatedPieces)
//        }

        return generatedPieces
    }

    // MARK: - Board cells -

    private func generateBoardCellViewModels() -> [BoardCellViewModel] {
        var generatedBoardCellViewModels = [BoardCellViewModel]()
        for row in 0...2 {
            for column in 0...2 {
                generatedBoardCellViewModels.append(BoardCellViewModel(with: row, column: column))
            }
        }

        subscribeCellViewModelsToDragUpdatesFromAPiece(generatedCellViewModels: generatedBoardCellViewModels)
        subscribeToCellPublishers(generatedCellViewModels: generatedBoardCellViewModels)

        return generatedBoardCellViewModels
    }

    private func subscribeCellViewModelsToDragUpdatesFromAPiece(generatedCellViewModels: [BoardCellViewModel]) {
        generatedCellViewModels.forEach {
            $0.subscribeToDragStart(self.pieceDragStartToCellsPublisher)
            $0.subscribeToDragEnded(self.pieceDragEndToCellsPublisher)
            $0.subscribeToNewOccupancy(self.newCellOccupiedPublisherForOriginCell)
        }
    }

    private func subscribeToCellPublishers(generatedCellViewModels: [BoardCellViewModel]) {
        generatedCellViewModels.forEach { cellViewModel in
            cellViewModel.newOccupancyPublisher.sink { (teamId, cellCenter, pieceId, cellId, previousCellId) in
                self.newCellOccupiedPublisherForOriginCell.send((pieceId, previousCellId))
            }
            .store(in: &cancellables)

            cellViewModel.newOccupancyPublisher.sink { (teamId, cellCenter, pieceId, cellId, previousCellId) in
                self.newCellOccupiedByPiecePublisher.send((teamId, cellCenter, pieceId, cellId))
            }
            .store(in: &cancellables)
            
            cellViewModel.newOccupancyPublisher.sink { (teamId, _, _, _, _) in
                self.newCellOccupiedByPiecePublisherForShelf.send((teamId))
            }
            .store(in: &cancellables)
        }
    }
    
    // MARK: - Host and peer shelves -
    
    private func generateShelfViewModel(with teamId: UUID) -> ShelfViewModel {
        let generatedViewModel = ShelfViewModel(with: teamId, color: teamId == hostId ? .red : .blue)
        generatedViewModel.subscribeToNewOccupancy(newCellOccupiedByPiecePublisherForShelf)
        
        generatedViewModel.refillSuccessPublisher.sink { teamId in
            self.shelfRefillPublisher.send(teamId)
        }
        .store(in: &cancellables)
        
        return generatedViewModel
    }

    // MARK: - Win logic and game reset -
    
    func checkWinner(teamId: UUID) {
//        var occupiedCellIndexes = boardCellViewModels
    }
    
}
