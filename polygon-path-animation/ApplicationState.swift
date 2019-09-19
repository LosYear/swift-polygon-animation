import Foundation
import SpriteKit

class ApplicationState {
    internal enum StateMode {
        case path
        case polygon
    }
    
    /// Which shape is currently edited (path or shape)
    var mode: StateMode = .path
    
    internal var pathPolygon: PathPolygon
    internal var shapePolygon: ShapePolygon
    
    internal var animationController: AnimationController
    
    var activePath: BasePolygon {
        switch mode {
        case .path:
            return pathPolygon
        case .polygon:
            return shapePolygon
        }
    }
    
    init(scene: SKScene) {
        pathPolygon = PathPolygon(scene: scene, lineWidth: 7, strokeColor: .systemBlue, vertexColor: .systemPurple, vertexRadius: 16, vertexPrefix: "p")
        shapePolygon = ShapePolygon(scene: scene, lineWidth: 4, strokeColor: .systemYellow, vertexColor: .systemGray, vertexRadius: 8)
        
        animationController = AnimationController(movingPath: pathPolygon, polygonPath: shapePolygon, duration: 12)
    }
}
