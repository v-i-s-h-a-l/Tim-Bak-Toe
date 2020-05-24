/// Source: https://developer.apple.com/documentation/swiftui/securefield/3289399-previewdevice#discussion
/// The above document lacks updates (at the time of writing this code)
/// Some additional devices have been added in this lis

// Please, feel free to fork/comment/contribute:
// https://gist.github.com/v-i-s-h-a-l/ffd070a79125766ef4add19bb5b247cd

/// 7th revision: with suggestion from @jayrhynas (twitter)

import SwiftUI

private enum PreviewDeviceName {
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

extension PreviewDevice {
    static let mac = PreviewDevice(rawValue: PreviewDeviceName.mac)

    static let iPhone6s = PreviewDevice(rawValue: PreviewDeviceName.iPhone6s)
    static let iPhone6sPlus = PreviewDevice(rawValue: PreviewDeviceName.iPhone6sPlus)
    static let iPhone7 = PreviewDevice(rawValue: PreviewDeviceName.iPhone7)
    static let iPhone7Plus = PreviewDevice(rawValue: PreviewDeviceName.iPhone7Plus)
    static let iPhone8 = PreviewDevice(rawValue: PreviewDeviceName.iPhone8)
    static let iPhone8Plus = PreviewDevice(rawValue: PreviewDeviceName.iPhone8Plus)
    static let iPhoneSE = PreviewDevice(rawValue: PreviewDeviceName.iPhoneSE)
    static let iPhoneSE2 = PreviewDevice(rawValue: PreviewDeviceName.iPhoneSE2)
    static let iPhoneX = PreviewDevice(rawValue: PreviewDeviceName.iPhoneX)
    static let iPhoneXs = PreviewDevice(rawValue: PreviewDeviceName.iPhoneXs)
    static let iPhoneXsMax = PreviewDevice(rawValue: PreviewDeviceName.iPhoneXsMax)
    static let iPhoneXʀ = PreviewDevice(rawValue: PreviewDeviceName.iPhoneXʀ)
    static let iPhone11 = PreviewDevice(rawValue: PreviewDeviceName.iPhone11)
    static let iPhone11Pro = PreviewDevice(rawValue: PreviewDeviceName.iPhone11Pro)
    static let iPhone11ProMax = PreviewDevice(rawValue: PreviewDeviceName.iPhone11ProMax)

    static let iPadMini_2 = PreviewDevice(rawValue: PreviewDeviceName.iPadMini_2)
    static let iPadMini_3 = PreviewDevice(rawValue: PreviewDeviceName.iPadMini_3)
    static let iPadMini_4 = PreviewDevice(rawValue: PreviewDeviceName.iPadMini_4)
    static let iPadMini_5thGen = PreviewDevice(rawValue: PreviewDeviceName.iPadMini_5thGen)

    static let iPadAir = PreviewDevice(rawValue: PreviewDeviceName.iPadAir)
    static let iPadAir_2 = PreviewDevice(rawValue: PreviewDeviceName.iPadAir_2)
    static let iPadAir_3rdGen = PreviewDevice(rawValue: PreviewDeviceName.iPadAir_3rdGen)

    static let iPadRetina = PreviewDevice(rawValue: PreviewDeviceName.iPadRetina)
    static let iPad_5thGen = PreviewDevice(rawValue: PreviewDeviceName.iPad_5thGen)
    static let iPad_6thGen = PreviewDevice(rawValue: PreviewDeviceName.iPad_6thGen)
    static let iPad_7thGen = PreviewDevice(rawValue: PreviewDeviceName.iPad_7thGen)

    static let iPadPro_9_7 = PreviewDevice(rawValue: PreviewDeviceName.iPadPro_9_7)
    static let iPadPro_10_5 = PreviewDevice(rawValue: PreviewDeviceName.iPadPro_10_5)
    static let iPadPro_11 = PreviewDevice(rawValue: PreviewDeviceName.iPadPro_11)
    static let iPadPro_11_2ndGen = PreviewDevice(rawValue: PreviewDeviceName.iPadPro_11_2ndGen)
    static let iPadPro_12_9 = PreviewDevice(rawValue: PreviewDeviceName.iPadPro_12_9)
    static let iPadPro_12_9_2ndGen = PreviewDevice(rawValue: PreviewDeviceName.iPadPro_12_9_2ndGen)
    static let iPadPro_12_9_3rdGen = PreviewDevice(rawValue: PreviewDeviceName.iPadPro_12_9_3rdGen)
    static let iPadPro_12_9_4thGen = PreviewDevice(rawValue: PreviewDeviceName.iPadPro_12_9_4thGen)

    static let appleTV = PreviewDevice(rawValue: PreviewDeviceName.appleTV)
    static let appleTV4K = PreviewDevice(rawValue: PreviewDeviceName.appleTV4K)
    static let appleTV4K_1080p = PreviewDevice(rawValue: PreviewDeviceName.appleTV4K_1080p)

    static let appleWatch_38 = PreviewDevice(rawValue: PreviewDeviceName.appleWatch_38)
    static let appleWatch_42 = PreviewDevice(rawValue: PreviewDeviceName.appleWatch_42)
    static let appleWatch2_38 = PreviewDevice(rawValue: PreviewDeviceName.appleWatch2_38)
    static let appleWatch2_42 = PreviewDevice(rawValue: PreviewDeviceName.appleWatch2_42)
    static let appleWatch3_38 = PreviewDevice(rawValue: PreviewDeviceName.appleWatch3_38)
    static let appleWatch3_42 = PreviewDevice(rawValue: PreviewDeviceName.appleWatch3_42)
    static let appleWatch4_40 = PreviewDevice(rawValue: PreviewDeviceName.appleWatch4_40)
    static let appleWatch4_44 = PreviewDevice(rawValue: PreviewDeviceName.appleWatch4_44)
    static let appleWatch5_40 = PreviewDevice(rawValue: PreviewDeviceName.appleWatch5_40)
    static let appleWatch5_44 = PreviewDevice(rawValue: PreviewDeviceName.appleWatch5_44)
}

// Example Usage:

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice(PreviewDevice.mac)
            ContentView()
                .previewDevice(PreviewDevice.iPhoneSE2)
            ContentView()
                .colorScheme(.dark)
                .previewDevice(PreviewDevice.iPhone8)
            ContentView()
                .previewDevice(PreviewDevice.appleTV)
                .previewDisplayName(PreviewDevice.appleTV.rawValue)
            ContentView()
                .previewDevice(PreviewDevice.appleWatch5_44)
        }
    }
}
