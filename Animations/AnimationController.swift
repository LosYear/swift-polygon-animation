import Foundation

/// Responsible for the animation process.
/// Defines how objects will move depending on time.
class AnimationController {
    // MARK: - Public properties
    
    /// Duration of the animation in seconds.
    let duration: Double
    
    /// The current state of the animation. Defined as double value in the range [0, 1)
    var progress: Double = 0 {
        didSet {
            animate()
        }
    }
    
    /// Represent whether the animation is run or not. Any change of the value will trigger progress reset.
    var isActive: Bool = false {
        didSet {
            reset()
            
            if isActive {
                startTime = DispatchTime.now()
            }
        }
    }
    
    // MARK: - Private properties
    
    private var pathPolygon: PathPolygon
    private var shapePolygon: ShapePolygon
    
    private var startTime: DispatchTime = DispatchTime.now()
    
    // MARK: - Public methods
    
    init(movingPath: PathPolygon, polygonPath: ShapePolygon, duration: Double) {
        self.pathPolygon = movingPath
        self.shapePolygon = polygonPath
        self.duration = duration
    }
    
    /// Changes the progress of animation according to the current timestamp
    func step() {
        if !isActive {
            return
        }
        
        let diff = Double(DispatchTime.now().uptimeNanoseconds - startTime.uptimeNanoseconds) / 1_000_000_000.0
        progress = (Double(diff) / duration).truncatingRemainder(dividingBy: 1)
    }
    
    // MARK: - Private methods
    
    /// Core logic of animation process, connects current progress with screen position
    private func animate() {
        pathPolygon.rotation = (Double.pi * 2) * progress
        shapePolygon.rotation = (Double.pi * 4) * progress
        
        let point = pathPolygon.getProgress(percentage: progress)
        shapePolygon.moveTo(position: point)
    }
    
    private func reset() {
        progress = 0
        
        if pathPolygon.points.count > 0 {
            shapePolygon.moveTo(position: pathPolygon.points[0], modifyOrignalPoints: true)
        }
    }
}
