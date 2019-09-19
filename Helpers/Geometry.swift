import CoreGraphics

func getDistance(p1: CGPoint, p2: CGPoint) -> Double {
    return fabs(Double(sqrt(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2))))
}

func rotatePoint(point: CGPoint, center: CGPoint, phi: Double) -> CGPoint {
    let newX = point.x - center.x
    let newY = point.y - center.y
    
    let rotatedX = newX * CGFloat(cos(phi)) + newY * CGFloat(sin(phi)) + center.x
    let rotatedY = -newX * CGFloat(sin(phi)) + newY * CGFloat(cos(phi)) + center.y
    
    return CGPoint(x: rotatedX, y: rotatedY)
}
