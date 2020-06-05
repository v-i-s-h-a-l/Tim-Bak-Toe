//
//  SettingsScreen.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 04/06/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

struct SettingsScreen: View {

    @Binding var currentScreen: Screen

    private let backButtonConfiguration = UIImage.SymbolConfiguration(pointSize: 32, weight: .heavy)

    var body: some View {
        ZStack {
            Theme.Col.gameBackground
                .edgesIgnoringSafeArea(.all)

            Text("Work in progress..")
                .font(.title)
            
            VStack(alignment: .leading) {
                Spacer()
                HStack {
                    Button(action: {
                        self.currentScreen = .home
                    }) {
                        ZStack(alignment: .leading) {
                            Circle()
                                .inset(by: -20)
                            .fill(Theme.Col.gameBackground)
                            .shadow(color: Theme.Col.lightSource, radius: 2, x: -2, y: -2)
                            .shadow(color: Theme.Col.shadowCasted, radius: 2, x: 2, y: 2)

                            Image(uiImage: UIImage(systemName: "arrowshape.turn.up.left.fill", withConfiguration: backButtonConfiguration)!)
                                .foregroundColor(.primary)
                        }
                    }
                    .frame(width: 44, height: 44)
                    .padding(60)

                    Spacer()
                }
            }
        }
    }
}

#if DEBUG

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen(currentScreen: .constant(.settings))
    }
}

#endif
