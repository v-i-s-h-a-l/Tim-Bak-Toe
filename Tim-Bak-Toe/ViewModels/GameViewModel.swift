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

class GameViewModel: ObservableObject {
    
    let pieceDragStartToFellowPiecesPublisher = PassthroughSubject<UUID, Never>()
    let pieceDragEndToFellowPiecesPublisher = PassthroughSubject<UUID, Never>()

    let pieceDragStartToCellsPublisher = PassthroughSubject<UUID?, Never>()
    let pieceDragEndToCellsPublisher = PassthroughSubject<(CGPoint, UUID, UUID?), Never>()

    let newCellOccupiedByPiecePublisher = PassthroughSubject<(CGPoint, UUID, UUID), Never>()
    let newCellOccupiedPublisherForOriginCell = PassthroughSubject<(UUID, UUID?), Never>()

    lazy var hostPieces: [PieceViewModel] = generatePiecesForHost()
    lazy var guestPieces: [PieceViewModel] = generatePiecesForPeer()
    lazy var boardCellViewModels: [[BoardCellViewModel]] = generateBoardCellViewModels()

    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Host pieces -

    private func generatePiecesForHost() -> [PieceViewModel] {
        let generatedHostPieces = [PieceViewModel(with: .circle1), PieceViewModel(with: .circle1), PieceViewModel(with: .circle1)]
        
        setupConnnectionsForDragStart(for: generatedHostPieces)
        setupConnnectionsForDragEnd(for: generatedHostPieces)
        
        return generatedHostPieces
    }

    private func setupConnnectionsForDragStart(for pieces: [PieceViewModel]) {
        // Receives information from specific piece
        pieces.forEach { $0.subscribeToDragStart(pieceDragStartToFellowPiecesPublisher) }

        // transmits info to all pieces and board cells
        pieces.forEach { pieceModel in
            pieceModel.dragStartedPublisher.sink { pieceID, cellId in
                self.pieceDragStartToFellowPiecesPublisher.send(pieceID)
            }
            .store(in: &cancellables)

            pieceModel.dragStartedPublisher.sink { pieceID, cellId in
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
        }

        // transmits info to all pieces and board cells
        pieces.forEach { pieceModel in
            pieceModel.draggedEndedPublisher.sink { location, pieceID, cellId in
                self.pieceDragEndToFellowPiecesPublisher.send(pieceID)
            }
            .store(in: &cancellables)

            pieceModel.draggedEndedPublisher.sink { location, pieceID, cellId in
                self.pieceDragEndToCellsPublisher.send((location, pieceID, cellId))
            }
            .store(in: &cancellables)
        }
    }
        
        // MARK: - Peer pieces -

    private func generatePiecesForPeer() -> [PieceViewModel] {
        let generatedHostPieces = [PieceViewModel(with: .circle2), PieceViewModel(with: .circle2), PieceViewModel(with: .circle2)]
                
        return generatedHostPieces
    }

    // MARK: - Board cells -

    private func generateBoardCellViewModels() -> [[BoardCellViewModel]] {
        var generatedBoardCellViewModels = [[BoardCellViewModel]]()
        for _ in 0...2 {
            var rowCells = [BoardCellViewModel]()
            for _ in 0...2 {
                rowCells.append(BoardCellViewModel())
            }
            generatedBoardCellViewModels.append(rowCells)
        }

        let flattened = generatedBoardCellViewModels.flatMap {
            $0.flatMap { $0 }
        }

        subscribeCellViewModelsToDragUpdatesFromAPiece(generatedCellViewModels: flattened)
        subscribeToCellPublishers(generatedCellViewModels: flattened)

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
            cellViewModel.newOccupancyPublisher.sink { (cellCenter, pieceId, cellId, previousCellId) in
                self.newCellOccupiedPublisherForOriginCell.send((pieceId, previousCellId))
            }
            .store(in: &cancellables)

            cellViewModel.newOccupancyPublisher.sink { (cellCenter, pieceId, cellId, previousCellId) in
                self.newCellOccupiedByPiecePublisher.send((cellCenter, pieceId, cellId))
            }
            .store(in: &cancellables)
        }
    }
}
