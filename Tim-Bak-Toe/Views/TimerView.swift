//
//  TimerView.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 25/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

struct TimerView: View {
    
    @ObservedObject var viewModel: TimerViewModel

    let isRightEdged: Bool

    @State private var originalSize: CGSize = .zero
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Theme.Col.boardCell)
                .cornerRadius(originalSize.height / 2)
                .overlay(
                    Rectangle()
                        .stroke(LinearGradient(Theme.Col.shadowCasted, Theme.Col.lightSource, startPoint: .top, endPoint: .bottom), lineWidth: 2)
                        .cornerRadius(originalSize.height / 2)
                        .blur(radius: 1))
            HStack {
                viewModel
                    .style
                    .timerGradient
                    .cornerRadius(originalSize.height / 2)
                    .frame(width: originalSize.width * (viewModel.isEmpty ? 0 : 1))

                Spacer()
            }
            .rotationEffect(.radians(isRightEdged ? .pi : 0), anchor: .center)
        }
        .zIndex(ZIndex.board)
        .overlay(GeometryReader{ proxy in
            Color.clear
                .onAppear {
                    self.originalSize = proxy.frame(in: .local).size
            }
        })
            .onTapGesture {
                self.viewModel.invokeEmptying()
                self.viewModel.invokeRefilling()
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(viewModel: TimerViewModel(with: UUID(), style: .X), isRightEdged: false).previewDevice(PreviewDevice.iPhoneSE2)
    }
}
