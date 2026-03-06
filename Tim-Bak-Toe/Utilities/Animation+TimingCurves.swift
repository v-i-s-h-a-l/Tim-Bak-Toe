import SwiftUI

extension Animation {
    public static func easeOutQuart(duration: Double) -> Animation {
        self.timingCurve(0.165, 0.84, 0.44, 1, duration: duration)
    }

    public static var easeOutQuart: Animation {
        Animation.timingCurve(0.165, 0.84, 0.44, 1)
    }

    public static func easeInOutBack(duration: Double) -> Animation {
        self.timingCurve(0.68, -0.55, 0.265, 1.55, duration: duration)
    }

    public static var easeInOutBack: Animation {
        Animation.timingCurve(0.68, -0.55, 0.265, 1.55)
    }

    public static func easeOutBack(duration: Double) -> Animation {
        self.timingCurve(0.175, 0.885, 0.32, 1.275, duration: duration)
    }

    public static var easeOutBack: Animation {
        Animation.timingCurve(0.175, 0.885, 0.32, 1.275)
    }

    public static func easeInBack(duration: Double) -> Animation {
        self.timingCurve(0.6, -0.28, 0.735, 0.045, duration: duration)
    }

    public static var easeInBack: Animation {
        Animation.timingCurve(0.6, -0.28, 0.735, 0.045)
    }

    public static func easeOutQuint(duration: Double) -> Animation {
        self.timingCurve(0.23, 1, 0.32, 1, duration: duration)
    }

    public static var easeOutQuint: Animation {
        Animation.timingCurve(0.23, 1, 0.32, 1)
    }

    public static func easeInOutQuart(duration: Double) -> Animation {
        self.timingCurve(0.77, 0, 0.175, 1, duration: duration)
    }

    public static var easeInOutQuart: Animation {
        Animation.timingCurve(0.77, 0, 0.175, 1)
    }
}
