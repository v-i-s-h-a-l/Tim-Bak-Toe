//
//  GameView.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 22/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

struct GameView: View {

    @Binding var showGameScreen: Bool
    @EnvironmentObject var viewModel: GameViewModel
    private let size: CGSize = UIScreen.main.bounds.size
    
    private var boardSize: CGSize {
        CGSize(width: size.width * Points.boardWidthMultiplier, height: size.width * Points.boardWidthMultiplier)
    }
    
    private var pieceSize: CGSize {
        CGSize(width: boardSize.width / 3 - (2 * Points.cellPadding), height: boardSize.height / 3 - (2 * Points.cellPadding))
    }
    
    var body: some View {
        ZStack {
            Theme.Col.gameBackground
            .edgesIgnoringSafeArea([.all])

            BoardView(boardSize: boardSize)

            PiecesContainerView(pieceSize: pieceSize)
            
            if viewModel.showWinnerView {
                WinnerView(message: viewModel.winMessage, onRestart: viewModel.onRestart, showGameScreen: $showGameScreen)
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }
}

struct GameView_Previews: PreviewProvider {
    
    @State static private var showGameScreen: Bool = true
    
    static var previews: some View {
        Group {
            NavigationView {
                GameView(showGameScreen: $showGameScreen).colorScheme(.dark)
                    .previewDevice(PreviewDevice.iPhoneSE2)
                    .environmentObject(GameViewModel())
            }
            NavigationView {
                GameView(showGameScreen: $showGameScreen).colorScheme(.light)
                    .previewDevice(PreviewDevice.iPhoneXʀ)
                    .environmentObject(GameViewModel())
            }
        }
    }
}
