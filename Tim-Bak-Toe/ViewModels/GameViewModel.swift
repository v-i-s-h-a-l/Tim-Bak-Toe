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
    let pieceDragEndToCellsPublisher = PassthroughSubject<(CGPoint, UUID?), Never>()

    lazy var hostPieces: [PieceViewModel] = generatePiecesForHost()
    lazy var boardCellViewModels: [[BoardCellViewModel]] = generateBoardCellViewModels()

    var cancellables = [AnyCancellable?]()
    
    // MARK: - Host pieces -

    private func generatePiecesForHost() -> [PieceViewModel] {
        let generatedHostPieces = [PieceViewModel(), PieceViewModel(), PieceViewModel()]
        
        setupConnnectionsForDragStart(for: generatedHostPieces)
        setupConnnectionsForDragEnd(for: generatedHostPieces)
        
        return generatedHostPieces
    }

    private func setupConnnectionsForDragStart(for pieces: [PieceViewModel]) {
        // Receives information from specific piece
        pieces.forEach { $0.subscribeToDragStart(pieceDragStartToFellowPiecesPublisher) }

        // transmits info to all pieces and board cells
        pieces.forEach { pieceModel in
            cancellables.append(pieceModel.dragStartedPublisher.sink { pieceID, cellId in
                self.pieceDragStartToFellowPiecesPublisher.send(pieceID)
                self.pieceDragStartToCellsPublisher.send(cellId)
            })
        }
    }

    private func setupConnnectionsForDragEnd(for pieces: [PieceViewModel]) {
        // Receive information from specific piece
        pieces.forEach { $0.subscribeToDragEnd(pieceDragEndToFellowPiecesPublisher) }

        // transmits info to all pieces and board cells
        pieces.forEach { pieceModel in
            cancellables.append(pieceModel.draggedEndedPublisher.sink { location, pieceID, cellId in
                self.pieceDragEndToFellowPiecesPublisher.send(pieceID)
                self.pieceDragEndToCellsPublisher.send((location, cellId))
            })
        }
    }
        
        // MARK: - Peer pieces -

    private func generatePiecesForPeer() -> [PieceViewModel] {
        return []
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

        subscribeCellViewModelsToDragUpdatesFromAPiece(generatedCellViewModels: generatedBoardCellViewModels)
        
        return generatedBoardCellViewModels
    }

    private func subscribeCellViewModelsToDragUpdatesFromAPiece(generatedCellViewModels: [[BoardCellViewModel]]) {
        let flattened = generatedCellViewModels.flatMap {
            $0.flatMap { $0 }
        }
        flattened.forEach {
            $0.subscribeToDragStart(self.pieceDragStartToCellsPublisher)
//            $0.subscribeToDragChanged(self.)
            $0.subscribeToDragEnded(self.pieceDragEndToCellsPublisher)
        }
    }
}
