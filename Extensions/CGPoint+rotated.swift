import CoreGraphics

extension CGPoint {
    /// Creates **copy** of point rotated by arbitrary angle
    ///
    /// - Parameters:
    ///     - angle: Arbitrary angle for rotation in radians
    ///     - center: Origin of rotation
    /// - Returns: Rotated copy of point

    func rotated(angle: Double, center: CGPoint) -> CGPoint {
        let newX = self.x - center.x
        let newY = self.y - center.y

        let rotatedX = newX * CGFloat(cos(angle)) + newY * CGFloat(sin(angle)) + center.x
        let rotatedY = -newX * CGFloat(sin(angle)) + newY * CGFloat(cos(angle)) + center.y

        return CGPoint(x: rotatedX, y: rotatedY)
    }
}
