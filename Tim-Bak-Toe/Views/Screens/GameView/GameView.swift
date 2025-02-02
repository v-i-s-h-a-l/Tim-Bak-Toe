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
        CGSize(width: boardSize.width / 3.0 - (2.0 * Points.cellPadding), height: boardSize.height / 3.0 - (2.0 * Points.cellPadding))
    }
    
    var body: some View {
        let timerHeight = pieceSize.height / 8.0
        let padding = pieceSize.height / 3.0

        return ZStack {
            Theme.Col.gameBackground
            .edgesIgnoringSafeArea([.all])

            VStack {
                Spacer()

                // Peer pieces
                PiecesContainer(pieceSize: pieceSize, pieces: viewModel.peerPieces)
                Spacer()

                // Peer timer
                Group {
                    TimerView(viewModel: viewModel.peerTimerViewModel, isRightEdged: true)
                        .frame(height: pieceSize.height / 8.0)
                        .padding([.leading, .trailing], padding)
                    Spacer()
                }

                // Board
                Group {
                    BoardView(boardSize: boardSize)
                    Spacer()
                }

                // Host timer
                Group {
                    TimerView(viewModel: viewModel.hostTimerViewModel, isRightEdged: false)
                        .frame(height: timerHeight)
                        .padding([.leading, .trailing], padding)
                    Spacer()
                }

                // Host pieces
                PiecesContainer(pieceSize: pieceSize, pieces: viewModel.hostPieces)
                Spacer()
            }
        }
        // status bar height
        .overlay(
            Group {
                EmptyView()
                if viewModel.showWinnerView {
                    WinnerView(onRestart: viewModel.onRestart, currentScreen: $currentScreen)
                }
            }
        )
        .onAppear {
            self.viewModel.onGameStart()
        }
    }
}

#if DEBUG

struct GameView_Previews: PreviewProvider {
        
    static var previews: some View {
        Group {
                GameView(currentScreen: .constant(.game)).colorScheme(.dark)
                    .environmentObject(GameViewModel())
                GameView(currentScreen: .constant(.game)).colorScheme(.light)
                    .previewDevice(PreviewDevice.iPhoneXʀ)
                    .environmentObject(GameViewModel())
                    .previewDisplayName(PreviewDeviceName.iPhone8)
            GameView(currentScreen: .constant(.game)).colorScheme(.light)
                .previewDevice(PreviewDevice.iPadAir_3rdGen)
                .environmentObject(GameViewModel())
                .previewDisplayName(PreviewDeviceName.iPadAir_3rdGen)
            GameView(currentScreen: .constant(.game)).colorScheme(.light)
                .previewDevice(PreviewDevice.iPadPro_12_9_4thGen)
                .environmentObject(GameViewModel())
                .previewDisplayName(PreviewDeviceName.iPadPro_12_9_4thGen)
        }
    }
}

#endif
