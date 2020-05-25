import SwiftUI

extension Animation {

    public static func easeInSin(duration: Double) -> Animation {
        return self.timingCurve(0.47, 0, 0.745, 0.715, duration: duration)
    }

    public static var easeInSin: Animation = Animation.timingCurve(0.47, 0, 0.745, 0.715)


    public static func easeOutSin(duration: Double) -> Animation {
        return self.timingCurve(0.39, 0.575, 0.565, 1, duration: duration)
    }

    public static var easeOutSin: Animation = Animation.timingCurve(0.39, 0.575, 0.565, 1)


    public static func easeInOutSine(duration: Double) -> Animation {
        return self.timingCurve(0.445, 0.05, 0.55, 0.95, duration: duration)
    }

    public static var easeInOutSine: Animation = Animation.timingCurve(0.445, 0.05, 0.55, 0.95)


    public static func easeInQuad(duration: Double) -> Animation {
        return self.timingCurve(0.55, 0.085, 0.68, 0.53, duration: duration)
    }

    public static var easeInQuad: Animation = Animation.timingCurve(0.55, 0.085, 0.68, 0.53)


    public static func easeOutQuad(duration: Double) -> Animation {
        return self.timingCurve(0.25, 0.46, 0.45, 0.94, duration: duration)
    }

    public static var easeOutQuad: Animation = Animation.timingCurve(0.25, 0.46, 0.45, 0.94)


    public static func easeInOutQuad(duration: Double) -> Animation {
        return self.timingCurve(0.455, 0.03, 0.515, 0.955, duration: duration)
    }

    public static var easeInOutQuad: Animation = Animation.timingCurve(0.455, 0.03, 0.515, 0.955)


    public static func easeInCubic(duration: Double) -> Animation {
        return self.timingCurve(0.55, 0.055, 0.675, 0.19, duration: duration)
    }

    public static var easeInCubic: Animation = Animation.timingCurve(0.55, 0.055, 0.675, 0.19)


    public static func easeOutCubic(duration: Double) -> Animation {
        return self.timingCurve(0.215, 0.61, 0.355, 1, duration: duration)
    }

    public static var easeOutCubic: Animation = Animation.timingCurve(0.215, 0.61, 0.355, 1)


    public static func easeInQuart(duration: Double) -> Animation {
        return self.timingCurve(0.895, 0.03, 0.685, 0.22, duration: duration)
    }

    public static var easeInQuart: Animation = Animation.timingCurve(0.895, 0.03, 0.685, 0.22)


    public static func easeOutQuart(duration: Double) -> Animation {
        return self.timingCurve(0.165, 0.84, 0.44, 1, duration: duration)
    }

    public static var easeOutQuart: Animation = Animation.timingCurve(0.165, 0.84, 0.44, 1)


    public static func easeInOutQuart(duration: Double) -> Animation {
        return self.timingCurve(0.77, 0, 0.175, 1, duration: duration)
    }

    public static var easeInOutQuart: Animation = Animation.timingCurve(0.77, 0, 0.175, 1)


    public static func easeInQuint(duration: Double) -> Animation {
        return self.timingCurve(0.755, 0.05, 0.855, 0.06, duration: duration)
    }

    public static var easeInQuint: Animation = Animation.timingCurve(0.755, 0.05, 0.855, 0.06)


    public static func easeOutQuint(duration: Double) -> Animation {
        return self.timingCurve(0.23, 1, 0.32, 1, duration: duration)
    }

    public static var easeOutQuint: Animation = Animation.timingCurve(0.23, 1, 0.32, 1)


    public static func easeInOutQuint(duration: Double) -> Animation {
        return self.timingCurve(0.86, 0, 0.07, 1, duration: duration)
    }

    public static var easeInOutQuint: Animation = Animation.timingCurve(0.86, 0, 0.07, 1)


    public static func easeInExpo(duration: Double) -> Animation {
        return self.timingCurve(0.95, 0.05, 0.795, 0.035, duration: duration)
    }

    public static var easeInExpo: Animation = Animation.timingCurve(0.95, 0.05, 0.795, 0.035)


    public static func easeOutExpo(duration: Double) -> Animation {
        return self.timingCurve(0.19, 1, 0.22, 1, duration: duration)
    }

    public static var easeOutExpo: Animation = Animation.timingCurve(0.19, 1, 0.22, 1)


    public static func easeInOutExpo(duration: Double) -> Animation {
        return self.timingCurve(1, 0, 0, 1, duration: duration)
    }

    public static var easeInOutExpo: Animation = Animation.timingCurve(1, 0, 0, 1)


    public static func easeInCirc(duration: Double) -> Animation {
        return self.timingCurve(0.6, 0.04, 0.98, 0.335, duration: duration)
    }

    public static var easeInCirc: Animation = Animation.timingCurve(0.6, 0.04, 0.98, 0.335)


    public static func easeOutCirc(duration: Double) -> Animation {
        return self.timingCurve(0.075, 0.82, 0.165, 1, duration: duration)
    }

    public static var easeOutCirc: Animation = Animation.timingCurve(0.075, 0.82, 0.165, 1)


    public static func easeInOutCirc(duration: Double) -> Animation {
        return self.timingCurve(0.785, 0.135, 0.15, 0.86, duration: duration)
    }

    public static var easeInOutCirc: Animation = Animation.timingCurve(0.785, 0.135, 0.15, 0.86)


    public static func easeInBack(duration: Double) -> Animation {
        return self.timingCurve(0.6, -0.28, 0.735, 0.045, duration: duration)
    }

    public static var easeInBack: Animation = Animation.timingCurve(0.6, -0.28, 0.735, 0.045)


    public static func easeOutBack(duration: Double) -> Animation {
        return self.timingCurve(0.175, 0.885, 0.32, 1.275, duration: duration)
    }

    public static var easeOutBack: Animation = Animation.timingCurve(0.175, 0.885, 0.32, 1.275)


    public static func easeInOutBack(duration: Double) -> Animation {
        return self.timingCurve(0.68, -0.55, 0.265, 1.55, duration: duration)
    }

    public static var easeInOutBack: Animation = Animation.timingCurve(0.68, -0.55, 0.265, 1.55)
}
