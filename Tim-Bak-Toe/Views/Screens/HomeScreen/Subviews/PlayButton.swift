//
//  PlayButton.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 04/06/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

struct PlayButton: View {
    
    @Binding var showGameScreen: Bool
    private let linearGradient = LinearGradient(Theme.Col.greenStart, Theme.Col.greenEnd, startPoint: .top, endPoint: .bottom)

    var body: some View {
        Button(action: {
            withAnimation {
                self.showGameScreen.toggle()
            }
        }) {
            Image(systemName: "play.fill")
                .foregroundColor(.white)
                .padding()
                .padding([.leading, .trailing], 60)
                .background(linearGradient)
        }
        .cornerRadius(40.0)
        .shadow(color: Theme.Col.shadowCasted, radius: 2, x: 2, y: 2)
        .padding(.bottom)
    }
}
