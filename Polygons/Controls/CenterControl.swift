import SpriteKit

class CenterControl {
    private var node: SKShapeNode
    
    private let scene: SKScene
    
    init(scene: SKScene, radius: CGFloat = 3, color: NSColor = NSColor.systemRed) {
        self.scene = scene
        
        node = SKShapeNode(circleOfRadius: radius)
        node.fillColor = color
        node.strokeColor = color
    }
    
    func draw(position: CGPoint) {
        node.position = position
        
        if node.parent == nil {
            scene.addChild(node)
        }
    }
}
