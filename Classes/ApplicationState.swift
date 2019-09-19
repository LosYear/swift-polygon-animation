import Foundation

class ApplicationState {
    enum StateMode {
        case path
        case polygon
    }
    
    var mode: StateMode = StateMode.path
    var movingPath: MovingPath?
    var polygonPath: PolygonPath?
    var progress: Double = 0
    
    var animationActive: Bool = false {
        didSet {
            if animationActive {
                polygonPath?.moveTo(position: (movingPath?.points[0])!, modifyOrignalPoints: true)
                
                animationStart = DispatchTime.now()
            }
        }
    }
    var animationStart: DispatchTime = DispatchTime.now()
    
    func getActivePath() -> BasePolygon? {
        if mode == .path {
            return movingPath
        }
        
        return polygonPath
    }
}
