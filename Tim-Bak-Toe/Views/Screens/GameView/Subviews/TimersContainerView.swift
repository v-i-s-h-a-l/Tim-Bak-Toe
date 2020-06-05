//
//  TimersContainerView.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 05/06/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

struct TimersContainerView: View {
    
    let pieceSize: CGSize
    @EnvironmentObject var viewModel: GameViewModel
    
    var body: some View {
        let timerHeight = pieceSize.height / 8.0
        let spacing = pieceSize.height * (4.0 / 3.0)
        let padding = pieceSize.height / 6.0

        return VStack {
            TimerView(viewModel: viewModel.peerTimerViewModel, isRightEdged: true)
                .frame(height: timerHeight)
                .padding([.leading, .trailing], padding)

            Spacer()
            
            TimerView(viewModel: viewModel.hostTimerViewModel, isRightEdged: true)
                .frame(height: timerHeight)
                .padding([.leading, .trailing], padding)

        }
        .padding([.top, .bottom], spacing)
    }
}
//#if DEBUG
//
//struct TimersContainerView_Previews: PreviewProvider {
//    static var previews: some View {
//        TimersContainerView()
//    }
//}
//
//#endif
