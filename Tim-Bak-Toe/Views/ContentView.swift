//
//  ContentView.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 22/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            NavigationLink(destination: GameView().environmentObject(GameViewModel()), label: { Text("Play").font(.largeTitle) })
        }
    }
}
