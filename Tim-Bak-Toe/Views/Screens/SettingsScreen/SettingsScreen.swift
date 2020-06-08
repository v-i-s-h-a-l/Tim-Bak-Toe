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
    
    private let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: Points.isPad ? 32 : 20, weight: .heavy)
    let random = [PieceStyle.X, PieceStyle.O].randomElement()!

    var body: some View {
        ZStack {
            Theme.Col.gameBackground
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Group {
                    Spacer()
                    VStack {
                        SocialButton(contributor: .akb)
                            .padding()
                        SocialButton(contributor: .vishal)
                    }
                    Spacer()
                }

                Picker(selection: $gameSettings.preferredColorScheme, label: Text("Appearance")) {
                    Text("System").tag(0)
                    Text("Light").tag(1)
                    Text("Dark").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .padding([.trailing, .leading])

                Group {
                    Toggle(isOn: $gameSettings.soundOn) {
                            Image(uiImage: UIImage(systemName: gameSettings.soundOn ? "speaker.2.fill" : "speaker.slash.fill", withConfiguration: symbolConfiguration)!)
                                .renderingMode(.template)
                                .foregroundColor(Color.primary)
                        .padding(.trailing)
                    }
                    .padding()

                    Stepper(value: $gameSettings.timerDuration, in: 3.0...10.0) {
                        VStack {
                            TimerView(viewModel: TimerViewModel(with: UUID(), style: random), isRightEdged: false)
                                .frame(height: 20)
                            
                            Text("\(Int(gameSettings.timerDuration)) seconds").font(Points.isPad ? .title : .body)
                        }
                        .padding(.trailing)
                    }
                    .padding()
                }
                .frame(maxWidth: Points.isPad ? 350 : 250)
                .padding()
                
                Spacer()
                
                SettingsButton(title: "Back") {
                    self.currentScreen = .home
                }
            }
        }
        .colorScheme(gameSettings.preferredColorScheme == 1 ? .light : .dark)
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
