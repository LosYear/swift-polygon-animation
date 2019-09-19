import SpriteKit

class Scene : SKScene {
    var state: ApplicationState!
    
    var selectedVertex: Int?
    
    override func didMove(to view: SKView) {
        //        backgroundColor = .white
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if state!.animationActive {
            let diff = Double(DispatchTime.now().uptimeNanoseconds - state.animationStart.uptimeNanoseconds) / 1_000_000_000.0
            let percentage = (Double(diff) / 12
                ).truncatingRemainder(dividingBy: 1)
            
            state.movingPath?.rotation = (Double.pi * 2) * percentage
            state.polygonPath?.rotation = (-Double.pi * 4) * percentage
            state.polygonPath?.moveTo(position: ((state.movingPath?.getProgress(percentage: percentage))!))
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        let touchPoint = event.location(in: self)
        
        state.getActivePath()?.addPoint(point: touchPoint)
        
        let clickedPoint = self.atPoint(touchPoint)
        
        if state.movingPath!.finished && clickedPoint.name != nil && clickedPoint.name!.prefix(1) == "p"{
            
            var name = clickedPoint.name!
            name.remove(at: name.startIndex)
            selectedVertex = Int(name)
        }
    }
    
    
    override func mouseDragged(with event: NSEvent) {
        if let index = selectedVertex {
            let touchPoint = event.location(in: self)
            
            state.movingPath?.orignalPoints[index] = rotatePoint(point: touchPoint, center: (state.movingPath?.getOriginalCenter())!, phi: -state.movingPath!.rotation)
            state.movingPath?.points[index] = touchPoint
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        selectedVertex = nil
    }
}
