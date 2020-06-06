//
//  WinnerView.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 25/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

struct WinnerView: View {

    let onRestart: () -> ()
    @Binding var currentScreen: Screen

    var body: some View {
        ZStack {
            VStack {
                
                GreenButton(title: "Restart", action: onRestart)
                    .padding(.top, Points.screenEdgePadding)
   
                Spacer()

                GreenButton(title: "Home") {
                    self.currentScreen = .home
                }
                .padding(.bottom, Points.screenEdgePadding)
            }
        }
    }
}
