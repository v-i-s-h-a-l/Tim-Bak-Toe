//
//  GameView.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 22/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

struct GameView: View {
    var body: some View {
        ZStack {
            Color.gray.opacity(0.8)
        }
        .edgesIgnoringSafeArea([.all])
        .navigationBarBackButtonHidden(true)
        .statusBar(hidden: true)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
