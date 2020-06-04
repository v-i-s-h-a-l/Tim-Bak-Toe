//
//  StartGameView.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 26/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

struct HomeScreen: View {
    
    @Binding var showGameScreen: Bool
    @Binding var showSettingsScreen: Bool

    private let size: CGSize = UIScreen.main.bounds.size
    
    private var boardSize: CGSize {
        CGSize(width: size.width * Points.boardWidthMultiplier, height: size.width * Points.boardWidthMultiplier)
    }
    
    var body: some View {
        ZStack {
            EmptyView()
            if !showGameScreen {
                ZStack {
                    Theme.Col.gameBackground
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        HStack {
                            Image("XO3")
                                .renderingMode(.original)
                                .padding([.leading, .top], 40)
                                .padding([.bottom], 20)
                            Spacer()
                        }
                        
                        HStack {
                            Text("Tic tac toe")
                                .font(.title)
                                .foregroundColor(.primary)
                                .padding([.leading], 40)
                            Spacer()
                        }
                        HStack {
                            Text("Grab a friend and have a game")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .padding([.leading], 40)
                            Spacer()
                        }
                        
                        
                        BoardView(boardSize: boardSize).environmentObject(GameViewModel())
                        PlayButton(showGameScreen: $showGameScreen)
                        SettingsButton(showSettingsScreen: $showSettingsScreen)
                    }
                }
            }
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeScreen(showGameScreen: .constant(false), showSettingsScreen: .constant(false))
                .previewDevice(PreviewDevice.iPhoneSE2)
            HomeScreen(showGameScreen: .constant(false), showSettingsScreen: .constant(false))
                .previewDevice(PreviewDevice.iPhoneXʀ)
                .colorScheme(.dark)
        }
    }
}
