//
//  ContentView.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 22/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var showGameScreen: Bool = false
    
    var body: some View {
        NavigationView {
            TabView {
                NavigationLink(destination: GameView(showGameScreen: $showGameScreen).environmentObject(GameViewModel()), isActive: $showGameScreen) {
                    StartGameView(showGameScreen: $showGameScreen)
                }
                .tabItem() {
                    Image(systemName: "play.rectangle.fill")
                }
                    
                WinnerView(message: "Message", onRestart: {}, showGameScreen:  $showGameScreen)
                    .tabItem {
                        Image(systemName: "slider.horizontal.3")
                }
            }
            .navigationBarHidden(true)
        }
    }
}
    
struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice(PreviewDevice.iPhoneSE2)
        }
    }
}
