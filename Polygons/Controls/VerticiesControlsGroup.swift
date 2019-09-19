import SpriteKit

class VerticiesControlsGroup {
    private let scene: SKScene
    
    private var verticies: [SKShapeNode] = []
    
    private let vertexColor: NSColor
    private let vertexRadius: CGFloat
    private let namePrefix: String
    
    init(scene: SKScene, vertexColor: NSColor, vertexRadius: CGFloat, namePrefix: String) {
        self.scene = scene
        self.vertexColor = vertexColor
        self.vertexRadius = vertexRadius
        self.namePrefix = namePrefix
    }
    
    func draw(points: [CGPoint]) {
        // Remove or add existing/new nodes
        if verticies.count > points.count {
            removeExcess(count: verticies.count - points.count)
        } else if verticies.count < points.count {
            fillLack(count: points.count - verticies.count)
        }
        
        // Reposition
        for (index, vertex) in verticies.enumerated() {
            vertex.position = points[index]
            
            if vertex.parent == nil {
                scene.addChild(vertex)
            }
        }
    }
    
    private func removeExcess(count: Int) {
        scene.removeChildren(in: Array(verticies.suffix(from: count)))
        
        verticies = verticies.dropLast(count)
    }
    
    private func fillLack(count: Int) {
        for i in 0..<count {
            makeNewVertex(index: verticies.count + i)
        }
    }
    
    private func makeNewVertex(index: Int) {
        let vertex = SKShapeNode(circleOfRadius: vertexRadius)
        
        vertex.position = CGPoint.zero
        vertex.fillColor = vertexColor
        vertex.strokeColor = vertexColor
        vertex.name = namePrefix + String(index)
        
        verticies.append(vertex)
    }
}
