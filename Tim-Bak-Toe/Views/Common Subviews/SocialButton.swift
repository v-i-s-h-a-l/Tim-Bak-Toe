//
//  SocialButton.swift
//  XO3
//
//  Created by Vishal Singh on 08/06/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import SwiftUI

enum Contributor: String {
    case akb = "Alistair"
    case vishal = "Vishal"
    
    var twitterURL: URL {
        switch self {
        case .akb: return URL(string: "https://twitter.com/alistairkb")!
        case .vishal: return URL(string: "https://twitter.com/v_s_h_a_l")!
        }
    }

    var message: String {
        switch self {
        case .akb: return "🎨 by \(rawValue)"
        case .vishal: return "👨🏻‍💻 by \(rawValue)"
        }
    }
}

struct SocialButton: View {

    let contributor: Contributor
    
    var body: some View {
        SettingsButton(title: contributor.message) {
            UIApplication.shared.open(self.contributor.twitterURL, options: [:], completionHandler: nil)
        }
    }
}

struct SocialButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SocialButton(contributor: .vishal)
            SocialButton(contributor: .akb)
        }
    }
}
