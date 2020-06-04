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
    private let linearGradient = LinearGradient(Theme.Col.greenStart, Theme.Col.greenEnd, startPoint: .top, endPoint: .bottom)

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
                    Text("Grab a friend and have a game")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding([.leading], 40)
                    Spacer()
                }
                
                            
                BoardView(boardSize: boardSize).environmentObject(GameViewModel())
                
                Button(action: {
                    self.showGameScreen.toggle()
                }) {
                    Image(systemName: "play.fill")
                        .foregroundColor(.white)
                        .padding()
                        .padding([.leading, .trailing], 60)
                    .background(linearGradient)
                }
                .cornerRadius(40.0)
                .shadow(color: Theme.Col.shadowCasted, radius: 5, x: 2, y: 2)
                .padding(.bottom)

                Button(action: {
                    self.showGameScreen.toggle()
                }) {
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(.primary)
                        .padding()
                        .padding([.leading, .trailing], 60)
                        .background(Theme.Col.gameBackground)
                }
                .cornerRadius(40.0)
                .shadow(color: Theme.Col.lightSource, radius: 2, x: -2, y: -2)
                .shadow(color: Theme.Col.shadowCasted, radius: 2, x: 2, y: 2)
                .padding(.bottom)
                Spacer(minLength: 40)
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeScreen(showGameScreen: .constant(false))
                .previewDevice(PreviewDevice.iPhoneSE2)
            HomeScreen(showGameScreen: .constant(false))
                .previewDevice(PreviewDevice.iPhoneXʀ)
                .colorScheme(.dark)
        }
    }
}
