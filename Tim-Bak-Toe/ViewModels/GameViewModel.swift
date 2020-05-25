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
    
    @Published var hostScore: Int = 0
    @Published var peerScore: Int = 0

    @Published var showWinnerView: Bool = false
    
    private var winnerId: UUID? {
        didSet {
            if winnerId != nil {
                showWinnerView = true
                if winnerId == hostId {
                    hostScore += 1
                } else {
                    peerScore += 1
                }
            }
        }
    }
    
    var winMessage: String {
        let teamName: String
        if winnerId == hostId {
            teamName = "RED"
        } else {
            teamName = "BLUE"
        }
        return "Congratulations!!\n🎉🎊\nTeam \(teamName) wins!"
    }
//
//    @Published var hostPieces: [PieceViewModel] = []
//    @Published var peerPieces: [PieceViewModel] = []
//    @Published var boardCellViewModels: [BoardCellViewModel] = []
//    @Published var hostShelfViewModel: ShelfViewModel
//    @Published var peerShelfViewModel: ShelfViewModel
    
    /* private */ lazy var hostPieces: [PieceViewModel] = generatePiecesForHost()
    /* private */ lazy var peerPieces: [PieceViewModel] = generatePiecesForPeer()
    /* private */ lazy var boardCellViewModels: [BoardCellViewModel] = generateBoardCellViewModels()
    /* private */ lazy var hostShelfViewModel: ShelfViewModel = generateShelfViewModel(with: hostId)
    /* private */ lazy var peerShelfViewModel: ShelfViewModel = generateShelfViewModel(with: peerId)

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
                self.newCellOccupiedByPiecePublisher.send((teamId, cellCenter, pieceId, cellId))
            }
            .store(in: &cancellables)
            
            cellViewModel.newOccupancyPublisher.sink { (teamId, _, pieceId, _, previousCellId) in
                self.newCellOccupiedPublisherForOriginCell.send((pieceId, previousCellId))
                self.checkWinner(teamId: teamId)
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
        guard winnerId == nil else { return }

        let occupiedIndexes = boardCellViewModels.filter { $0.teamId == teamId }
            .map { $0.indexPath }
        guard occupiedIndexes.count == 3 else { return }
        
        let occupiedIndexesSet = Set(occupiedIndexes)

        withAnimation {
            self.winnerId = possibleWinnerIndexes.contains(occupiedIndexesSet) ? teamId : nil
        }
    }
    
    private let possibleWinnerIndexes = Set([
        Set(["0,0", "0,1", "0,2"]),
        Set(["0,0", "1,0", "2,0"]),
        Set(["0,0", "1,1", "2,2"]),
        Set(["2,0", "1,1", "0,2"]),
        Set(["1,0", "1,1", "1,2"]),
        Set(["0,1", "1,1", "2,1"]),
        Set(["2,0", "2,1", "2,2"]),
        Set(["0,2", "1,2", "2,2"]),
    ])
}
