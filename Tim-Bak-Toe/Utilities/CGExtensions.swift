import CoreGraphics

extension CGPoint {
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGSize {
        CGSize(width: lhs.x - rhs.x, height: lhs.y - rhs.y)
    }
}

extension CGSize {
    static func + (lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }

    static func - (lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }
}

extension CGRect {
    var center: CGPoint {
        CGPoint(x: origin.x + size.width / 2, y: origin.y + size.height / 2)
    }
}
