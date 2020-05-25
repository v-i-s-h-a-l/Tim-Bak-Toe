//
//  GameView.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 22/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

struct GameView: View {

//    @EnvironmentObject var gameSettings
    @EnvironmentObject var viewModel: GameViewModel
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
            ScoreView(hostScore: viewModel.hostScore, peerScore: viewModel.peerScore)
                .padding([.top])
            .padding([.top])
            .padding()
            .padding()

            VStack {
                Spacer()
                GridStack(rows: 3, columns: 3, content: cell)
                    .frame(width: boardSize.width, height: boardSize.height)
                Spacer()
                Spacer()
            }
            .zIndex(ZIndex.board)

            PiecesContainerView(pieceSize: pieceSize)
            
            if viewModel.showWinnerView {
                WinnerView(message: viewModel.winMessage, onRestart: viewModel.onRestart)
            }
        }
        .edgesIgnoringSafeArea([.all])
        .navigationBarBackButtonHidden(true)
        .statusBar(hidden: true)

    }
    
    func cell(atRow row: Int, column: Int) -> some View {
        return BoardCellView(viewModel: viewModel.boardCellViewModels[row * 3 + column])
            .padding(5)
    }
}

struct GameView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            GameView().colorScheme(.dark)
                .previewDevice(PreviewDevice.iPhoneSE2)
            GameView().colorScheme(.light)
                .previewDevice(PreviewDevice.iPhoneXʀ)
        }
    }
}
