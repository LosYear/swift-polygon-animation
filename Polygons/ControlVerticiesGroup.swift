import SpriteKit

class VerticiesControlsGroup {
    private let scene: SKScene
    
    let vertexColor: NSColor
    let vertexRadius: CGFloat
    let namePrefix: String
    
    init(scene: SKScene, vertexColor: NSColor, vertexRadius: CGFloat, namePrefix: String){
        self.scene = scene
        self.vertexColor = vertexColor
        self.vertexRadius = vertexRadius
        self.namePrefix = namePrefix
    }
}
