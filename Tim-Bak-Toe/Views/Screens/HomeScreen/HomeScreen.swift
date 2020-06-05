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
                    Text("Grab a friend to play")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding([.leading], 40)
                    Spacer()
                }
                
                
                BoardView(boardSize: boardSize).environmentObject(GameViewModel())
                PlayButton(currentScreen: $currentScreen)
                SettingsButton(currentScreen: $currentScreen)
            }
        }
    }
}

#if DEBUG

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeScreen(currentScreen: .constant(.home))
                .previewDevice(PreviewDevice.iPhoneSE2)
            HomeScreen(currentScreen: .constant(.home))
                .previewDevice(PreviewDevice.iPhoneXʀ)
                .colorScheme(.dark)
        }
    }
}

#endif
