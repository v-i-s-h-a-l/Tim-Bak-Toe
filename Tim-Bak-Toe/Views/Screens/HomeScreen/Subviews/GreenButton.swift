//
//  PlayButton.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 04/06/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

struct GreenButton: View {

    let title: String
    let action: () -> ()

    private let linearGradient = LinearGradient(Theme.Col.greenStart, Theme.Col.greenEnd, startPoint: .top, endPoint: .bottom)
    private let shadowSize: CGFloat = Points.isPad ? 5.0 : 2.0
    private let padding: CGFloat = Points.isPad ? 120 : 60

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(Points.isPad ? .title : .body)
                .kerning(2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(Points.isPad ? 30 : 15)
                .padding([.leading, .trailing], padding)
        }
        .background(linearGradient)
        .cornerRadius(60.0)
        .shadow(color: Theme.Col.shadowCasted, radius: shadowSize, x: shadowSize, y: shadowSize)
        .padding(.bottom)
    }
}
