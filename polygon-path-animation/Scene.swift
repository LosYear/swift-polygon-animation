import SpriteKit

class Scene: SKScene {
    var state: ApplicationState!
    
    var selectedVertex: Int?
    
    override func update(_ currentTime: TimeInterval) {
        state.animationController.step()
    }
    
    override func mouseDown(with event: NSEvent) {
        let touchPoint = event.location(in: self)
        
        state.activePath.addPoint(touchPoint)
        
        let clickedPoint = atPoint(touchPoint)
        
        if state.pathPolygon.pathClosed, clickedPoint.name != nil, clickedPoint.name!.prefix(1) == "p" {
            var name = clickedPoint.name!
            name.remove(at: name.startIndex)
            
            selectedVertex = Int(name)
        }
    }
    
    override func mouseDragged(with event: NSEvent) {
        if let index = selectedVertex {
            let touchPoint = event.location(in: self)
            state.pathPolygon.modifyPoint(index: index, newValue: touchPoint)
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        selectedVertex = nil
    }
}
