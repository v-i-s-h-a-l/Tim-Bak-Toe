//
//  GameView.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 22/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

struct GameView: View {

    @Binding var currentScreen: Screen
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
                WinnerView(message: viewModel.winMessage, onRestart: viewModel.onRestart, currentScreen: $currentScreen)
            }
        }
        .statusBar(hidden: true)
    }
}

struct GameView_Previews: PreviewProvider {
        
    static var previews: some View {
        Group {
            NavigationView {
                GameView(currentScreen: .constant(.game)).colorScheme(.dark)
                    .previewDevice(PreviewDevice.iPhoneSE2)
                    .environmentObject(GameViewModel())
                    .previewDisplayName(PreviewDeviceName.iPhoneSE2)
            }
            NavigationView {
                GameView(currentScreen: .constant(.game)).colorScheme(.light)
                    .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
                    .environmentObject(GameViewModel())
                    .previewDisplayName(PreviewDeviceName.iPhone11ProMax)
            }
        }
    }
}
