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
    
    private let backButtonConfiguration = UIImage.SymbolConfiguration(pointSize: Points.isPad ? 32 : 20, weight: .heavy)

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
                        Image(uiImage: UIImage(systemName: gameSettings.soundOn ? "speaker.2.fill" : "speaker.slash.fill", withConfiguration: backButtonConfiguration)!)
                            .renderingMode(.template)
                            .foregroundColor(Color.primary)
                    }
                    .frame(maxWidth: 200)

                    Stepper(value: $gameSettings.timerDuration, in: 3.0...10.0) {
                        VStack {
                        TimerView(viewModel: TimerViewModel(with: UUID(), style: PieceStyle.O), isRightEdged: false)
                            .frame(height: 20)
                            .padding()
                            
                            Text("\(Int(gameSettings.timerDuration)) seconds").font(Points.isPad ? .title : .body)
                        }
                    }
                    .frame(maxWidth: Points.isPad ? 350 : 250)
                    .padding()
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
            SettingsScreen(currentScreen: .constant(.settings)).environmentObject(GameSettings.user)
                .colorScheme(.dark)
            SettingsScreen(currentScreen: .constant(.settings)).environmentObject(GameSettings.user)
            SettingsScreen(currentScreen: .constant(.settings)).environmentObject(GameSettings.user)
                .previewDevice(PreviewDevice.iPhoneSE2)
            SettingsScreen(currentScreen: .constant(.settings)).environmentObject(GameSettings.user)
                .previewDevice(PreviewDevice.iPhone11Pro)
        }
    }
}

#endif
