import CoreGraphics

func distance(_ p1: CGPoint, _ p2: CGPoint) -> Double {
    return fabs(Double(sqrt(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2))))
}
