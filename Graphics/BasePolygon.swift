import CoreGraphics
import SpriteKit

class BasePolygon {
    var points: [CGPoint] = [] {
        didSet {
            redrawAll()
        }
    }
    internal var orignalPoints: [CGPoint] = []
    
    var path: CGMutablePath = CGMutablePath()
    var shape: SKShapeNode = SKShapeNode()
    var shapeCenter: SKShapeNode = SKShapeNode()
    
    var scene: SKScene
    
    var controlsVerticies: [SKShapeNode] = []
    let vertexColor: SKColor
    let vertexRadius: CGFloat
    let vertexPrefix: String
    
    var finished: Bool = false {
        didSet {
            redrawAll()
        }
    }
    
    var rotation: Double = 0 {
        didSet  {
            let center = self.getOriginalCenter()
            
            for (index, point) in orignalPoints.enumerated() {
                points[index] = rotatePoint(point: point, center: center, phi: rotation)
            }
        }
    }
    
    init(scene: SKScene, lineWidth: CGFloat, strokeColor: SKColor, vertexColor: SKColor, vertexRadius: CGFloat, vertexPrefix: String = ""){
        self.scene = scene
        self.vertexColor = vertexColor
        self.vertexRadius = vertexRadius
        self.vertexPrefix = vertexPrefix
        
        shape.lineWidth = lineWidth
        shape.strokeColor = strokeColor
        scene.addChild(shape)
    }
    
    func addPoint(point: CGPoint) {
        if finished {
            return
        }
        
        orignalPoints.append(point)
        points.append(point)
    }
    
    func resetState() {
        rotation = 0
        points = orignalPoints
    }
    
    func getCenter() -> CGPoint{
        return getArbitraryCenter(points)
    }
    
    func getOriginalCenter() -> CGPoint {
        return getArbitraryCenter(orignalPoints)
    }
    
    func moveTo(position: CGPoint, modifyOrignalPoints: Bool = false) {
        let center = getCenter()
        
        let deltaX = center.x - position.x
        let deltaY = center.y - position.y
        
        points = points.map({ (point) -> CGPoint in
            return CGPoint(x: point.x - deltaX, y: point.y - deltaY)
        })
        
        if modifyOrignalPoints {
            orignalPoints = points
        }
    }
    
    internal func getArbitraryCenter(_ collection: [CGPoint]) -> CGPoint{
        var x: CGFloat = 0, y: CGFloat = 0
        
        for point in collection {
            x += point.x
            y += point.y
        }
        
        return CGPoint(x: x / CGFloat(points.count), y: y / CGFloat(points.count))
    }
    
    internal func redrawAll(){
        redrawPath()
        redrawVerticies()
        redrawCenter()
    }
    
    private func redrawPath(){
        path = CGMutablePath()
        
        for (index, point) in points.enumerated() {
            if index == 0 {
                path.move(to: point)
            }
            else {
                path.addLine(to: point)
            }
        }
        
        if finished {
            path.closeSubpath()
        }
        
        shape.path = path
    }
    
    private func redrawVerticies(){
        // Remove or add existing/new nodes
        
        if controlsVerticies.count > points.count {
            let excess = controlsVerticies.count - points.count
            
            scene.removeChildren(in: Array(controlsVerticies.suffix(from: excess)))
            controlsVerticies = controlsVerticies.dropLast(excess)
        } else if controlsVerticies.count < points.count {
            let lack = points.count - controlsVerticies.count
            
            for i in (0..<lack) {
                let vertex = SKShapeNode(circleOfRadius: vertexRadius)
                vertex.position = CGPoint.zero
                vertex.fillColor = vertexColor
                vertex.name = vertexPrefix + String(controlsVerticies.count + i)
                controlsVerticies.append(vertex)
            }
        }
        
        // Reposition
        for (index, vertex) in controlsVerticies.enumerated() {
            vertex.position = points[index]
            
            if vertex.parent == nil {
                scene.addChild(vertex)
            }
        }
        
    }
    
    private func redrawCenter(){
        if shapeCenter.parent != nil {
            scene.removeChildren(in: [shapeCenter])
        }
        shapeCenter = SKShapeNode(circleOfRadius: 3)
        shapeCenter.fillColor = .red
        shapeCenter.position = getCenter()
        
        scene.addChild(shapeCenter)
    }
}
