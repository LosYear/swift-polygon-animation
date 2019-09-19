import SpriteKit

/// Implements logic of the polygon which represents the movement path
class PathPolygon: BasePolygon {
    // MARK: - Public properties
    
    override var originalPoints: [CGPoint] {
        didSet {
            recalculatePerimeter()
        }
    }
    
    // MARK: - Private properties
    
    private var breakpoints: [Double] = []
    private var perimeter: Double = 0.0 {
        didSet {
            recalculateBreakpoints()
        }
    }
    
    // MARK: - Public methods
    
    override func addPoint(_ point: CGPoint) {
        super.addPoint(point)
        
        recalculatePerimeter()
    }
    
    /// Returns point on the polygon when n percents of the path are walked by starting from first vertex
    func getProgress(percentage: Double) -> CGPoint {
        let distance = percentage * perimeter
        let segment = getSegmentIndex(distance: distance)
        let distanceDelta = fabs(breakpoints[segment] - distance)
        let distanceDeltaPercentage = distanceDelta / fabs(breakpoints[segment] - breakpoints[(segment + 1) % breakpoints.count])
        
        let toSegment = (segment + 1) % points.count
        let toPoint = points[toSegment]
        let fromPoint = points[segment]
        
        let newX = CGFloat(toPoint.x - fromPoint.x) * CGFloat(distanceDeltaPercentage) + fromPoint.x
        let newY = CGFloat(toPoint.y - fromPoint.y) * CGFloat(distanceDeltaPercentage) + fromPoint.y
        
        return CGPoint(x: newX, y: newY)
    }
    
    func modifyPoint(index: Int, newValue: CGPoint) {
        originalPoints[index] = newValue.rotated(angle: -rotation, center: originalCenter)
        points[index] = newValue
    }
    
    // MARK: - Private methods
    
    private func recalculatePerimeter() {
        if originalPoints.count < 2 {
            perimeter = 0
            return
        }
        
        var tempPerimeter = 0.0
        
        for i in 0..<originalPoints.count {
            let nextIndex = (i + 1) % originalPoints.count
            tempPerimeter += distance(originalPoints[i], originalPoints[nextIndex])
        }
        
        perimeter = tempPerimeter
    }
    
    private func recalculateBreakpoints() {
        if originalPoints.count < 2 {
            return
        }
        
        var tempPerimeter = 0.0
        
        breakpoints.removeAll(keepingCapacity: true)
        breakpoints.append(0)
        
        for i in 0..<originalPoints.count {
            let nextIndex = (i + 1) % originalPoints.count
            tempPerimeter += distance(originalPoints[i], originalPoints[nextIndex])
            breakpoints.append(tempPerimeter)
        }
    }
    
    /// Finds the path segment where the point lies on, e.g. 0, 1, ...
    private func getSegmentIndex(distance: Double) -> Int {
        var segmentIndex = 0
        
        for (index, breakpoint) in breakpoints.enumerated() {
            if breakpoint <= distance {
                segmentIndex = index
            }
        }
        
        return segmentIndex
    }
}
