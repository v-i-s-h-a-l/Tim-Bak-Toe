//
//  SettingsButton.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 04/06/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

struct SettingsButton: View {
    
    @Binding var showSettingsScreen: Bool
    private let linearGradient = LinearGradient(Theme.Col.greenStart, Theme.Col.greenEnd, startPoint: .top, endPoint: .bottom)
    
    var body: some View {
        Button(action: {
            self.showSettingsScreen.toggle()
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
    }
}
