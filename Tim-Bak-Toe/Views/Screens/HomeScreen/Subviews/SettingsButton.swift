//
//  SettingsButton.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 04/06/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

struct SettingsButton: View {
    
    let action: () -> ()
    private let shadowSize: CGFloat = Points.isPad ? 5.0 : 2.0
    private let padding: CGFloat = Points.isPad ? 120 : 60

    var body: some View {
        Button(action: {
            self.action()
            Sound.tap.play()
        }) {
            Text("Settings")
                .font(Points.isPad ? .title : .body)
                .kerning(2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .padding(Points.isPad ? 30 : 15)
                .padding([.leading, .trailing], padding)
                .background(Theme.Col.gameBackground)
        }
        .cornerRadius(60.0)
        .shadow(color: Theme.Col.lightSource, radius: shadowSize, x: -shadowSize, y: -shadowSize)
        .shadow(color: Theme.Col.shadowCasted, radius: shadowSize, x: shadowSize, y: shadowSize)
        .padding(.bottom)        
    }
}
