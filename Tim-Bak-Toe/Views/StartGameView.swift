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
    private let linearGradient = LinearGradient(gradient: Gradient(colors: [Color.blue, Color.red]), startPoint: .top, endPoint: .bottom)

    var body: some View {
        Button(action: {
            self.showGameScreen.toggle()
        }) {
            Text("PLAY")
                .font(.largeTitle)
                .fontWeight(.black)
                .foregroundColor(Color.white)
                .kerning(10)
                .multilineTextAlignment(.center)
                .padding()
        }
        .background(linearGradient)
        .border(Color.accentColor, width: 4)
        .cornerRadius(10.0)
    }
}

struct StartGameView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen(showGameScreen: .constant(false))
    }
}
