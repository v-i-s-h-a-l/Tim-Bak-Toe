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
            if let winnerId = winnerId {
                showWinnerView = true
                if winnerId == hostId {
                    hostScore += 1
                } else {
                    peerScore += 1
                }
                winPublisher.send(winnerId)
            } else {
                showWinnerView = false
            }
        }
    }
//
//    var winMessage: String {
//        let teamName: String
//        if winnerId == hostId {
//            teamName = "RED"
//        } else {
//            teamName = "BLUE"
//        }
//        return "Congratulations!!\n🎉🎊\nTeam \(teamName) wins!"
//    }
    
    lazy var hostPieces: [PieceViewModel] = generatePiecesForHost()
    lazy var peerPieces: [PieceViewModel] = generatePiecesForPeer()
    lazy var boardCellViewModels: [BoardCellViewModel] = generateBoardCellViewModels()
    lazy var hostTimerViewModel: TimerViewModel = generateTimerViewModel(with: hostId)
    lazy var peerTimerViewModel: TimerViewModel = generateTimerViewModel(with: peerId)
    
    private var cancellables = Set<AnyCancellable>()
    
    private let pieceDragStartToFellowPiecesPublisher = PassthroughSubject<(UUID, UUID), Never>()
    private let pieceDragEndToFellowPiecesPublisher = PassthroughSubject<(UUID, UUID), Never>()
    
    private let pieceDragEndToCellsPublisher = PassthroughSubject<(UUID, CGPoint, UUID, UUID?), Never>()
    
    private let newCellOccupiedByPiecePublisher = PassthroughSubject<(UUID, CGPoint, UUID, UUID), Never>()
    private let newCellOccupiedPublisherForOriginCell = PassthroughSubject<(UUID, UUID?), Never>()
    private let newCellOccupiedByPiecePublisherForShelf = PassthroughSubject<UUID, Never>()
    
    private let emptyTimerPublisher = PassthroughSubject<UUID, Never>()
    
    private let winPublisher = PassthroughSubject<UUID, Never>()
    private let restartPublisher = PassthroughSubject<Void, Never>()
    
    // MARK: - Host pieces -
    
    private func generatePiecesForHost() -> [PieceViewModel] {
        let generatedHostPieces = [PieceViewModel(with: .X), PieceViewModel(with: .X), PieceViewModel(with: .X)]
        
        setupConnnectionsForDragStart(for: generatedHostPieces)
        setupConnnectionsForDragEnd(for: generatedHostPieces)
        
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
        }
    }
    
    private func setupConnnectionsForDragEnd(for pieces: [PieceViewModel]) {
        // Receive information from specific piece
        pieces.forEach {
            $0.subscribeToTimerEmptied(emptyTimerPublisher)
            $0.subscribeToNewOccupancy(newCellOccupiedByPiecePublisher)
            $0.subscribeToDragEnd(pieceDragEndToFellowPiecesPublisher)
            $0.subscribeToRestart(restartPublisher)
            $0.subscribeToWin(winPublisher)
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
        let generatedPieces = [PieceViewModel(with: .O), PieceViewModel(with: .O), PieceViewModel(with: .O)]
        
        setupConnnectionsForDragStart(for: generatedPieces)
        setupConnnectionsForDragEnd(for: generatedPieces)
        
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
            $0.subscribeToDragEnded(self.pieceDragEndToCellsPublisher)
            $0.subscribeToNewOccupancy(self.newCellOccupiedPublisherForOriginCell)
            $0.subscribeToRestart(restartPublisher)
        }
    }
    
    private func subscribeToCellPublishers(generatedCellViewModels: [BoardCellViewModel]) {
        generatedCellViewModels.forEach { cellViewModel in
            cellViewModel.newOccupancyPublisher.sink { (teamId, cellCenter, pieceId, cellId, previousCellId) in
                self.newCellOccupiedByPiecePublisher.send((teamId, cellCenter, pieceId, cellId))
            }
            .store(in: &cancellables)
            
            cellViewModel.newOccupancyPublisher.sink { (teamId, _, _, _, _) in
                self.newCellOccupiedByPiecePublisherForShelf.send((teamId))
            }
            .store(in: &cancellables)
            
            cellViewModel.newOccupancyPublisher.sink { (teamId, _, pieceId, _, previousCellId) in
                self.newCellOccupiedPublisherForOriginCell.send((pieceId, previousCellId))
                self.checkWinner(teamId: teamId)
            }
            .store(in: &cancellables)
        }
    }
    
    // MARK: - Host and peer shelves -
    
    private func generateTimerViewModel(with teamId: UUID) -> TimerViewModel {
        let generatedViewModel = TimerViewModel(with: teamId, style: teamId == hostId ? PieceStyle.X : PieceStyle.O)
        generatedViewModel.subscribeToNewOccupancy(newCellOccupiedByPiecePublisherForShelf)
        generatedViewModel.subscribeToWin(winPublisher)
        generatedViewModel.subscribeToRestart(restartPublisher)
        generatedViewModel.subscribeToEmptiedTimer(emptyTimerPublisher)
        
        generatedViewModel.emptyPublisher
            .sink { teamId in
            self.emptyTimerPublisher.send(teamId)
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
    
    func onRestart() {
        withAnimation {
            self.winnerId = nil
        }
        restartPublisher.send(())
    }
}
