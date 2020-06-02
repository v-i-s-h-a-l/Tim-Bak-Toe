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
        VStack {
            HStack(spacing: 5) {
                ForEach(viewModel.hostPieces) {
                    PieceView(viewModel: $0, size: self.pieceSize)
                        .padding([.trailing])
                }
            }
            .padding([.top])
            
            Spacer()
            
            HStack(spacing: 5) {
                ForEach(viewModel.peerPieces) {
                    PieceView(viewModel: $0, size: self.pieceSize)
                    .padding([.leading])
                }
            }
            .padding([.bottom])
        }
    }
}

struct PiecesContainerView_Previews: PreviewProvider {
    static var previews: some View {
        PiecesContainerView(pieceSize: CGSize(width: 50, height: 50)).environmentObject(GameViewModel())
    }
}
