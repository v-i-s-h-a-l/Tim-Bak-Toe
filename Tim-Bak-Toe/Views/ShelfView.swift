//
//  ShelfView.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 25/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

struct ShelfView: View {
    
    @ObservedObject var viewModel: ShelfViewModel

    let isRightEdged: Bool

    @State private var originalSize: CGSize = .zero
    
    var body: some View {
        HStack {
            if isRightEdged {
                Spacer()
            }
            viewModel.color
                .frame(width: originalSize.width * (viewModel.isEmpty ? 0 : 1))
            if !isRightEdged {
                Spacer()
            }
        }
        .zIndex(ZIndex.board)
        .overlay(GeometryReader{ proxy in
            Color.clear
                .onAppear {
                    self.originalSize = proxy.frame(in: .local).size
            }
        })
    }
}

//struct ShelfView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShelfView().previewDevice(PreviewDevice.iPhoneSE2)
//    }
//}
