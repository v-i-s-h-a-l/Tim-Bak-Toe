//
//  PlayButton.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 04/06/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

struct PlayButton: View {
    
    @Binding var currentScreen: Screen
    private let linearGradient = LinearGradient(Theme.Col.greenStart, Theme.Col.greenEnd, startPoint: .top, endPoint: .bottom)
    let shadowSize: CGFloat = Points.isPad ? 5.0 : 2.0
    let padding: CGFloat = Points.isPad ? 120 : 60

    var body: some View {
        Button(action: {
            withAnimation {
                self.currentScreen = .game
            }
        }) {
            Text("Play Now")
                .font(Points.isPad ? .title : .body)
                .kerning(2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(Points.isPad ? 30 : 15)
                .padding([.leading, .trailing], padding)
                .background(linearGradient)
        }
        .cornerRadius(60.0)
        .shadow(color: Theme.Col.shadowCasted, radius: shadowSize, x: shadowSize, y: shadowSize)
        .padding(.bottom)
    }
}
