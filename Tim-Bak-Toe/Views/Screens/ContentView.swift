//
//  ContentView.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 22/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

enum Screen {
    case onboarding, home, settings, game
}

struct ContentView: View {

    @Environment(\.colorScheme) var colorScheme
    @State var currentScreen: Screen = .onboarding

    var body: some View {
        Group {
            if currentScreen == .onboarding {
                OnboardingScreen(currentScreen: $currentScreen)
            }
            if currentScreen == .home {
                HomeScreen(currentScreen: $currentScreen)
            }
            if currentScreen == .game {
                GameView(currentScreen: $currentScreen).environmentObject(GameViewModel())
            }
            if currentScreen == .settings {
                SettingsScreen(currentScreen: $currentScreen)
                    .environmentObject(GameSettings.user)
            }
        }
        .colorScheme(GameSettings.user.preferredColorScheme ?? colorScheme)
        .statusBar(hidden: withAnimation { currentScreen == .game })
        .onAppear {
            let isFirstLaunch = !UserDefaults.standard.bool(forKey: "AlreadyLaunched")
            self.currentScreen = isFirstLaunch ? .onboarding : .home
            UserDefaults.standard.set(true, forKey: "AlreadyLaunched")
        }
    }
}
    
#if DEBUG

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice(PreviewDevice.iPhoneSE2)
            ContentView()
                .previewDevice(PreviewDevice.iPhoneXʀ)
        }
    }
}

#endif
