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
    @EnvironmentObject var gameSettings: GameSettings
    
    private let backButtonConfiguration = UIImage.SymbolConfiguration(pointSize: 32, weight: .heavy)

    var body: some View {
        return ZStack {
            Theme.Col.gameBackground
                .edgesIgnoringSafeArea(.all)

            VStack {
                Group {
                    Spacer()
                    Spacer()
                }

                Group {
                    Toggle(isOn: $gameSettings.soundOn) {
                        Image(systemName: (gameSettings.soundOn ? "speaker.2.fill" : "speaker.slash.fill"))
                            .aspectRatio(1.0, contentMode: .fit)
                            .foregroundColor(Color.primary)
                    }
                    .frame(maxWidth: 200)

                    Stepper(value: $gameSettings.timerDuration, in: 4.0...10.0) {
                        VStack {
                            Image(systemName: "timer")
                            Text("\(Int(gameSettings.timerDuration)) seconds")
                        }
                    }
                    .frame(maxWidth: 250)
                }
                .padding()

                Spacer()

                SettingsButton(title: "Back") {
                    self.currentScreen = .home
                }
            }
        }
    }
}

#if DEBUG

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsScreen(currentScreen: .constant(.settings)).environmentObject(GameSettings())
                .colorScheme(.dark)
            SettingsScreen(currentScreen: .constant(.settings)).environmentObject(GameSettings())
        }
    }
}

#endif
