//
//  GameView.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 22/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

struct GameView: View {
    
    @ObservedObject var viewModel = GameViewModel()
    private let size: CGSize = UIScreen.main.bounds.size
    
    private var boardSize: CGSize {
        CGSize(width: size.width * 0.9, height: size.width * 0.9)
    }
    
    private var pieceSize: CGSize {
        CGSize(width: boardSize.width / (3 * 1.4), height: boardSize.height / (3 * 1.4))
    }
    
    var body: some View {
        ZStack {
            Theme.Col.gameBackground
            VStack {
                Spacer()
                GridStack(rows: 3, columns: 3, content: cell)
                    .frame(width: boardSize.width, height: boardSize.height)
                Spacer()
            }
            .zIndex(ZIndex.board)
            VStack {
                HStack {
                    ForEach(viewModel.peerPieces) {
                        PieceView(viewModel: $0, size: self.pieceSize)
                            .padding([.leading, .trailing], -10)
                    }
                    .padding([.top])
                    .padding([.top])
                    .padding([.top])
                }
                Spacer()
                HStack {
                    ForEach(viewModel.hostPieces) {
                        PieceView(viewModel: $0, size: self.pieceSize)
                            .padding([.leading, .trailing], -10)
                    }
                    .padding([.bottom])
                    .padding([.bottom])
                    .padding([.bottom])
                }
            }
        }
        .edgesIgnoringSafeArea([.all])
        .navigationBarBackButtonHidden(true)
        .statusBar(hidden: true)
    }
    
    func cell(atRow row: Int, column: Int) -> some View {
        return BoardCellView(viewModel: viewModel.boardCellViewModels[row][column])
            .padding(5)
    }
}

struct GameView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            GameView().colorScheme(.dark)
                .previewDevice(PreviewDevice.iPadPro_12_9)
            GameView().colorScheme(.light).previewDevice(PreviewDevice.iPhoneSE)
        }
    }
}
