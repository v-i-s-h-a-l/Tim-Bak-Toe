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
            NavigationLink(destination: GameView(showGameScreen: $showGameScreen).environmentObject(GameViewModel()), isActive: $showGameScreen) {
                HomeScreen(showGameScreen: $showGameScreen)
            }
        }
        .navigationBarHidden(true)
        .navigationBarTitle("Some", displayMode: .inline)
        .statusBar(hidden: true)
    }
}
    
struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice(PreviewDevice.iPhoneSE2)
            ContentView()
                .previewDevice(PreviewDevice.iPhoneXʀ)
        }
    }
}
