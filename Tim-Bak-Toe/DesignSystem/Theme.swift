import SwiftUI

enum Theme {
    enum Col {
        static let piece = Color("piece")
        static let gameBackground = Color("background")
        static let boardCell = Color("boardCell")
        static let lightSource = Color("lightSource")
        static let shadowCasted = Color("shadowCasted")
        static let redStart = Color("redStart")
        static let redEnd = Color("redEnd")
        static let blueStart = Color("blueStart")
        static let blueEnd = Color("blueEnd")
        static let greenStart = Color("greenStart")
        static let greenEnd = Color("greenEnd")
    }
}

extension LinearGradient {
    init(_ colors: Color..., startPoint: UnitPoint = .topLeading, endPoint: UnitPoint = .bottomTrailing) {
        self.init(gradient: Gradient(colors: colors), startPoint: startPoint, endPoint: endPoint)
    }
}
