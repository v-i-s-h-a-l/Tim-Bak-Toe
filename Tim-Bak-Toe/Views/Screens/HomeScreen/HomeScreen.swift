//
//  StartGameView.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 26/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

struct HomeScreen: View {
    
    @Binding var currentScreen: Screen

    private let size: CGSize = UIScreen.main.bounds.size
    
    private var boardSize: CGSize {
        CGSize(width: size.width * Points.boardWidthMultiplier, height: size.width * Points.boardWidthMultiplier)
    }
    
    var body: some View {
        ZStack {
            Theme.Col.gameBackground
                .edgesIgnoringSafeArea(.all)
            BoardView(boardSize: boardSize).environmentObject(GameViewModel())

            VStack {
                Group {
                    HStack {
                        Image(decorative: "XO3")
                            .renderingMode(.original)
                            .padding([.top], 40)
                            .padding([.bottom], 20)
                        Spacer()
                    }
                    HStack {
                        Text("Tic Tac Toe")
                            .font(Points.isPad ? .largeTitle : .title)
                            .fontWeight(.bold)
                            .kerning(2)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    HStack {
                        Text("Grab a friend to play")
                            .font(Points.isPad ? .title : .body)
                            .kerning(1)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
                .padding(.leading, Points.isPad ? 160 : 40)
                
                Spacer()

                GreenButton(title: "Play Now") {
                    self.currentScreen = .game
                }
                .padding([.top])
                SettingsButton(title: "Settings") {
                    self.currentScreen = .settings
                }
                    .padding([.bottom])
            }
        }
        // status bar height
        .padding(.top, -20)

    }
}

#if DEBUG

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeScreen(currentScreen: .constant(.home))
            .previewDevice(PreviewDevice.iPadMini_5thGen)
            HomeScreen(currentScreen: .constant(.home))
                .previewDevice(PreviewDevice.iPhoneSE2)
            HomeScreen(currentScreen: .constant(.home))
                .previewDevice(PreviewDevice.iPhoneXʀ)
                .colorScheme(.dark)
        }
    }
}

#endif
