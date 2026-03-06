import SwiftUI

enum Contributor: String {
    case akb = "Alistair"
    case vishal = "Vishal"

    var url: URL {
        switch self {
        case .akb: return URL(string: "http://akbmedia.co.uk")!
        case .vishal: return URL(string: "https://twitter.com/v_s_h_a_l")!
        }
    }

    var message: String {
        switch self {
        case .akb: return "Art by \(rawValue)"
        case .vishal: return "Code by \(rawValue)"
        }
    }
}

struct SocialButton: View {
    let contributor: Contributor

    @Environment(\.openURL) private var openURL

    var body: some View {
        NeuomorphicButton(title: contributor.message) {
            openURL(contributor.url)
        }
    }
}
