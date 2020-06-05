//
//  OnboardingScreen.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 04/06/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

struct OnboardingScreen: View {
    
    @Binding var currentScreen: Screen
    
    private let personImageConfiguration = UIImage.SymbolConfiguration(pointSize: 100, weight: .medium)
    
    var body: some View {
        ZStack {
            Theme.Col.gameBackground
                .edgesIgnoringSafeArea(.all)
            VStack {
                Group {
                    HStack {
                        Image("XO3")
                            .renderingMode(.original)
                        Spacer()
                    }
                    .padding(40)
                    
                    Spacer()
                    Image(uiImage: UIImage(systemName: "person.2", withConfiguration: personImageConfiguration)!)
                        .foregroundColor(Color.gray)

                    Spacer()
                    Text("Tic tac toe")
                        .font(.title)
                        .fontWeight(.bold)
                        .kerning(2)
                        .foregroundColor(.primary)
                    Spacer()
                }
                Group {
                    Text(
                        "Welcome to tic tac toe\nwith a twist.\nThe turns are timed and\nyou are limited to three pieces each.\n\nGrab a friend to play")
                        .font(.body)
                        .kerning(1)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(UIColor.systemGray))
                    Spacer()
                    Spacer()
                    PlayButton(currentScreen: $currentScreen)
                    Spacer()
                    Spacer()
                }
            }
        }
    }
}

#if DEBUG

struct OnboardingScreen_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OnboardingScreen(currentScreen: .constant(.onboarding))
            
            OnboardingScreen(currentScreen: .constant(.onboarding))
                .colorScheme(.dark)
                .previewDevice(PreviewDevice.iPhoneXsMax)
        }
    }
}

#endif
