//
//  PreviewProviderHelper.swift
//  Tim-Bak-Toe
//
//  Created by Vishal Singh on 23/05/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

/// Source: https://developer.apple.com/documentation/swiftui/securefield/3289399-previewdevice#discussion
/// The above document lacks updates (at the time of writing this code)
/// Some additional devices have been added in this lis

extension PreviewDevice {
    static let mac = "Mac"

    static let iPhone6s = "iPhone 6s"
    static let iPhone6sPlus = "iPhone 6s Plus"
    static let iPhone7 = "iPhone 7"
    static let iPhone7Plus = "iPhone 7 Plus"
    static let iPhone8 = "iPhone 8"
    static let iPhone8Plus = "iPhone 8 Plus"
    static let iPhoneSE = "iPhone SE (1st generation)"
    static let iPhoneSE2 = "iPhone SE (2nd generation)"
    static let iPhoneX = "iPhone X"
    static let iPhoneXs = "iPhone Xs"
    static let iPhoneXsMax = "iPhone Xs Max"
    static let iPhoneXʀ = "iPhone Xʀ"
    static let iPhone11 = "iPhone 11"
    static let iPhone11Pro = "iPhone 11 Pro"
    static let iPhone11ProMax = "iPhone 11 Pro Max"

    static let iPadMini_2 = "iPad mini 2"
    static let iPadMini_3 = "iPad mini 3"
    static let iPadMini_4 = "iPad mini 4"
    static let iPadMini_5thGen = "iPad mini (5th generation)"

    static let iPadAir = "iPad Air"
    static let iPadAir_2 = "iPad Air 2"
    static let iPadAir_3rdGen = "iPad Air (3rd generation)"

    static let iPadRetina = "iPad Retina"
    static let iPad_5thGen = "iPad (5th generation)"
    static let iPad_6thGen = "iPad (6th generation)"
    static let iPad_7thGen = "iPad (7th generation)"

    static let iPadPro_9_7 = "iPad Pro (9.7-inch)"
    static let iPadPro_10_5 = "iPad Pro (10.5-inch)"
    static let iPadPro_11 = "iPad Pro (11-inch)"
    static let iPadPro_11_2ndGen = "iPad Pro (11-inch) (2nd generation)"
    static let iPadPro_12_9 = "iPad Pro (12.9-inch)"
    static let iPadPro_12_9_2ndGen = "iPad Pro (12.9-inch) (2nd generation)"
    static let iPadPro_12_9_3rdGen = "iPad Pro (12.9-inch) (3rd generation)"
    static let iPadPro_12_9_4thGen = "iPad Pro (12.9-inch) (4th generation)"

    static let appleTV = "Apple TV"
    static let appleTV4K = "Apple TV 4K"
    static let appleTV4K_1080p = "Apple TV 4K (at 1080p)"

    static let appleWatch_38 = "Apple Watch - 38mm"
    static let appleWatch_42 = "Apple Watch - 42mm"
    static let appleWatch2_38 = "Apple Watch Series 2 - 38mm"
    static let appleWatch2_42 = "Apple Watch Series 2 - 42mm"
    static let appleWatch3_38 = "Apple Watch Series 3 - 38mm"
    static let appleWatch3_42 = "Apple Watch Series 3 - 42mm"
    static let appleWatch4_40 = "Apple Watch Series 4 - 40mm"
    static let appleWatch4_44 = "Apple Watch Series 4 - 44mm"
    static let appleWatch5_40 = "Apple Watch Series 5 - 40mm"
    static let appleWatch5_44 = "Apple Watch Series 5 - 44mm"
}


// Example Usage:

struct SContentView_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            ContentView()
//                .previewDevice(PreviewDevice(rawValue: PreviewDevice.mac))
//            ContentView()
//                .previewDevice(PreviewDevice(rawValue: PreviewDevice.iPadPro_12_9_4thGen))
//            ContentView()
//                .previewDevice(PreviewDevice(rawValue: PreviewDevice.appleTV))
//            ContentView()
//                .previewDevice(PreviewDevice(rawValue: PreviewDevice.appleWatch5_44))
//            ContentView()
                .previewDevice(PreviewDevice(rawValue: PreviewDevice.iPhoneSE))
                ContentView()
            .previewDevice(PreviewDevice(rawValue: PreviewDevice.iPhoneSE2))
        }
    }
}
