//
//  PiecesContainerView.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 25/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

struct PiecesContainerView: View {
    
    let pieceSize: CGSize
    @EnvironmentObject var viewModel: GameViewModel
    
    @State private var hostZIndex: Double = ZIndex.playerPiecePlaced
    @State private var peerZIndex: Double = ZIndex.playerPiecePlaced

    var body: some View {
        let spacingForPieces = pieceSize.height / 5.0
        let padding = pieceSize.height / (Points.isPad ? 5.0 : 3.0)
        return VStack {
            HStack(spacing: spacingForPieces) {
                ForEach(0..<viewModel.peerPieces.count) { index in
                    PieceView(zIndexOfContainer: self.$peerZIndex, viewModel: self.viewModel.peerPieces[index], size: self.pieceSize)
                        .setAccessibilityIdentifier(element: .peerPiece(index))
                }
            }
            .zIndex(peerZIndex)
            
            Spacer()
            
            HStack(spacing: spacingForPieces) {
                ForEach(0..<viewModel.hostPieces.count) { index in
                    PieceView(zIndexOfContainer: self.$hostZIndex, viewModel: self.viewModel.hostPieces[index], size: self.pieceSize)
                        .setAccessibilityIdentifier(element: .hostPiece(index))
                }
            }
            .zIndex(hostZIndex)
        }
        .padding([.top, .bottom], padding)
    }
}

#if DEBUG

struct PiecesContainerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PiecesContainerView(pieceSize: CGSize(width: 90, height: 90)).environmentObject(GameViewModel())
            PiecesContainerView(pieceSize: CGSize(width: 90, height: 90)).environmentObject(GameViewModel())
                .previewDevice(PreviewDevice.iPadAir)
        }
    }
}

#endif
