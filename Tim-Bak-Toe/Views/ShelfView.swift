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
    
    private var size: CGSize?
    
    var body: some View {
        HStack {
            Color.green
//                .frame(width: refillWidth, height: 200)
//                .animation(.easeOutCubic(duration: duration))
            Spacer()
        }
    }
}

//struct ShelfView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShelfView().previewDevice(PreviewDevice.iPhoneSE2)
//    }
//}
