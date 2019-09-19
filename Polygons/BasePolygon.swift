import CoreGraphics
import SpriteKit

/// Implements base logic of screen polygon
class BasePolygon {
    // MARK: - Public properties
    
    var points: [CGPoint] = [] {
        didSet {
            draw()
        }
    }
    
    var pathClosed: Bool = false {
        didSet {
            draw()
        }
    }
    
    var rotation: Double = 0 {
        didSet {
            let center = originalCenter
            
            for (index, point) in originalPoints.enumerated() {
                points[index] = point.rotated(angle: rotation, center: center)
            }
        }
    }
    
    /// Center of visible shape
    var center: CGPoint {
        return getArbitraryCenter(points)
    }
    
    /// Center of the internal shape, can be different from the visible center
    var originalCenter: CGPoint {
        return getArbitraryCenter(originalPoints)
    }
    
    // MARK: - Private properties
    
    /// Stores an additional copy of polygon's points. Used while performing rotation to avoid computation inaccuracy.
    internal var originalPoints: [CGPoint] = []
    
    internal var path: CGMutablePath = CGMutablePath()
    internal var shape: SKShapeNode = SKShapeNode()
    
    internal var scene: SKScene
    
    internal var verticiesControls: VerticiesControlsGroup
    internal var centerControl: CenterControl
    
    // MARK: - Public methods
    
    init(scene: SKScene, lineWidth: CGFloat, strokeColor: SKColor, vertexColor: SKColor, vertexRadius: CGFloat, vertexPrefix: String = "") {
        self.scene = scene
        self.verticiesControls = VerticiesControlsGroup(scene: scene, vertexColor: vertexColor, vertexRadius: vertexRadius, namePrefix: vertexPrefix)
        self.centerControl = CenterControl(scene: scene)
        
        shape.lineWidth = lineWidth
        shape.strokeColor = strokeColor
        
        scene.addChild(shape)
    }
    
    func addPoint(_ point: CGPoint) {
        if pathClosed {
            return
        }
        
        originalPoints.append(point)
        points.append(point)
    }
    
    /// Moves polygon's center to the given position.
    /// - Parameters:
    ///     - position: New center.
    ///     - modifyOrignalPoints:
    ///         If false modifies only the visible shape, if true both original and visible polygons are moved.
    func moveTo(position: CGPoint, modifyOrignalPoints: Bool = false) {
        let deltaX = center.x - position.x
        let deltaY = center.y - position.y
        
        points = points.map { (point) -> CGPoint in
            CGPoint(x: point.x - deltaX, y: point.y - deltaY)
        }
        
        if modifyOrignalPoints {
            originalPoints = points
        }
    }
    
    // MARK: - Private methods
    
    /// Calculates center of arbitrary points collection
    private func getArbitraryCenter(_ collection: [CGPoint]) -> CGPoint {
        var x: CGFloat = 0, y: CGFloat = 0
        
        for point in collection {
            x += point.x
            y += point.y
        }
        
        return CGPoint(x: x / CGFloat(points.count), y: y / CGFloat(points.count))
    }
    
    /// Completely redraws the polygon including all controls.
    internal func draw() {
        redrawPath()
        verticiesControls.draw(points: points)
        centerControl.draw(position: center)
    }
    
    /// Redraws only the visible shape.
    private func redrawPath() {
        path = CGMutablePath()
        
        for (index, point) in points.enumerated() {
            if index == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        
        if pathClosed {
            path.closeSubpath()
        }
        
        shape.path = path
    }
}
