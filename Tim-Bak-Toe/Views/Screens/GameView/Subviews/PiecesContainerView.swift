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
                ForEach(viewModel.peerPieces) {
                    PieceView(viewModel: $0, size: self.pieceSize)
                        .padding([.trailing], padding)
                }
            }
            .padding([.bottom], padding)

            Spacer()

            HStack(spacing: spacingForPieces) {
                ForEach(viewModel.hostPieces) {
                    PieceView(viewModel: $0, size: self.pieceSize)
                        .padding([.leading], padding)
                }
            }
            .padding([.top], padding)
        }
        .padding([.top, .bottom], padding)
    }
}

struct PiecesContainerView_Previews: PreviewProvider {
    static var previews: some View {
        PiecesContainerView(pieceSize: CGSize(width: 90, height: 90)).environmentObject(GameViewModel())
    }
}
