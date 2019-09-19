import SpriteKit

class MovingPath : BasePolygon {
    internal var breakpoints: [Double] = []
    internal var perimeter: Double = 0.0
    
    override var orignalPoints: [CGPoint] {
        didSet {
            perimeter = calculatePerimeter()
            initBreakpoints()
        }
    }
    
    override func addPoint(point: CGPoint) {
        super.addPoint(point: point)
        
        perimeter = calculatePerimeter()
        initBreakpoints()
    }
    
    internal func calculatePerimeter() -> Double {
        if orignalPoints.count < 2 {
            return 0
        }
        
        var sum = 0.0
        
        for i in 0..<orignalPoints.count {
            let nextIndex = (i + 1) % orignalPoints.count
            sum += getDistance(p1: orignalPoints[i], p2: orignalPoints[nextIndex])
        }
        
        return sum
    }
    
    internal func initBreakpoints() {
        if orignalPoints.count < 2 {
            return
        }
        
        var perimeter = 0.0
        
        breakpoints.removeAll(keepingCapacity: true)
        breakpoints.append(0)
        
        for i in 0..<orignalPoints.count {
            let nextIndex = (i + 1) % orignalPoints.count
            perimeter += getDistance(p1: orignalPoints[i], p2: orignalPoints[nextIndex])
            breakpoints.append(perimeter)
        }
    }
    
    func getSegmentIndex(distance: Double) -> Int {
        var bpIndex = 0
        
        for (index, breakpoint) in breakpoints.enumerated() {
            if breakpoint <= distance {
                bpIndex = index
            }
        }
        
        return bpIndex
    }
    
    func getProgress(percentage: Double) -> CGPoint {
        let distance = percentage * perimeter
        let segment = getSegmentIndex(distance: distance)
        let distanceDelta = fabs(breakpoints[segment] - distance)
        let distanceDeltaPercentage = distanceDelta / fabs(breakpoints[segment] - breakpoints[(segment + 1) % breakpoints.count])
        
        let toSegment = (segment +  1) % points.count
        let toPoint = points[toSegment]
        let fromPoint = points[segment]
        
        let newX = CGFloat(toPoint.x - fromPoint.x) * CGFloat(distanceDeltaPercentage) + fromPoint.x
        let newY = CGFloat(toPoint.y - fromPoint.y) * CGFloat(distanceDeltaPercentage) + fromPoint.y
        
        return CGPoint(x: newX, y: newY)
    }
}
