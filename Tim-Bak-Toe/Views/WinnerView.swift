//
//  WinnerView.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 25/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

struct WinnerView: View {
    
    let message: String
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.red.opacity(0.7), Color.blue.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
            VStack {
                Text(message)
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding(50)
                Button(action: {
                }) {
                    Text("Re🤝start")
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding()
                }
                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.red]), startPoint: .top, endPoint: .bottom)
                    .cornerRadius(10.0)
                )
                .shadow(radius: 10.0)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct WinnerView_Previews: PreviewProvider {
//    @State static var some :Bool = false
    
    static var previews: some View {
        WinnerView(message: "Congratulations!!\n🎉🎊\nTeam Red wins!")
    }
}
