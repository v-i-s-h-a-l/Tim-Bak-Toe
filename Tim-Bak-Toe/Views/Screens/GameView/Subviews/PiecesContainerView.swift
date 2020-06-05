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
    
    var body: some View {
        let spacingForPieces = pieceSize.height / 11.0
        let padding = pieceSize.height / 6.0
        return VStack {
            HStack(spacing: spacingForPieces) {
                ForEach(0..<viewModel.peerPieces.count) { index in
                    PieceView(viewModel: self.viewModel.peerPieces[index], size: self.pieceSize)
                        .padding([.leading], padding)
                        .setAccessibilityIdentifier(element: .peerPiece(index))
                }
            }
            .padding([.bottom], padding)
            
            Spacer()
            
            HStack(spacing: spacingForPieces) {
                ForEach(0..<viewModel.hostPieces.count) { index in
                    PieceView(viewModel: self.viewModel.hostPieces[index], size: self.pieceSize)
                        .padding([.leading], padding)
                        .setAccessibilityIdentifier(element: .hostPiece(index))
                }
            }
            .padding([.top], padding)
        }
        .padding([.top, .bottom], padding)
    }
}

#if DEBUG

struct PiecesContainerView_Previews: PreviewProvider {
    static var previews: some View {
        PiecesContainerView(pieceSize: CGSize(width: 90, height: 90)).environmentObject(GameViewModel())
    }
}

#endif
