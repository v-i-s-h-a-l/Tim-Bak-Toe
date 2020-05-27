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
            Spacer()
            HStack {
                HStack {
                    ForEach(viewModel.hostPieces) {
                        PieceView(viewModel: $0, size: self.pieceSize)
                            .padding([.trailing], -self.pieceSize.width)
                    }
                    .padding()
                    Spacer()
                }
                .background(
                    ShelfView(viewModel: viewModel.hostShelfViewModel, isRightEdged: false)
                )

                Spacer()

                HStack {
                    Spacer()
                    ForEach(viewModel.peerPieces) {
                        PieceView(viewModel: $0, size: self.pieceSize)
                            .padding([.leading], -self.pieceSize.width)
                    }
                    .padding()
                }
                .background(
                    ShelfView(viewModel: viewModel.peerShelfViewModel, isRightEdged: true)
                )
            }
            .padding([.bottom])
            .padding([.bottom])
            .padding([.bottom])

        }
    }
}

struct PiecesContainerView_Previews: PreviewProvider {
    static var previews: some View {
        PiecesContainerView(pieceSize: CGSize(width: 50, height: 50)).environmentObject(GameViewModel())
    }
}
