//
//  ScoreView.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 25/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

struct ScoreView: View {
    
    let hostScore: Int
    let peerScore: Int
    
    var body: some View {
        VStack {
            HStack {
                Text("\(hostScore)")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.red)
                    .padding([.leading, .trailing])
                Text("Scores")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                Text("\(peerScore)")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.blue)
                    .padding([.leading, .trailing])
            }
            Spacer()
        }
    }
}

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreView(hostScore: 3, peerScore: 4)
    }
}
