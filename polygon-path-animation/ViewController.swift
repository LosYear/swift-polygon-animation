import Cocoa
import SpriteKit

class ViewController: NSViewController {
    var state: ApplicationState?
    
    @IBOutlet var skView: SKView!
    
    @IBOutlet var pathModeButton: NSButton!
    @IBOutlet var polygonModeButton: NSButton!
    
    @IBOutlet var toggleAnimationButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let view = self.skView {
            let scene = Scene(size: CGSize(width: view.frame.width * 2, height: view.frame.height * 2))
            state = ApplicationState(scene: scene)
            scene.state = state
            
            view.ignoresSiblingOrder = true
            scene.scaleMode = .aspectFill
            
            view.presentScene(scene)
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    @IBAction func setPathMode(_ sender: Any) {
        pathModeButton.bezelColor = .systemBlue
        polygonModeButton.bezelColor = nil
        
        state?.mode = .path
    }
    
    @IBAction func setPolygonMode(_ sender: Any) {
        pathModeButton.bezelColor = nil
        polygonModeButton.bezelColor = .systemBlue
        
        state?.mode = .polygon
    }
    
    @IBAction func closePath(_ sender: Any) {
        state?.activePath.pathClosed = true
    }
    
    @IBAction func startAnimation(_ sender: Any) {
        state?.animationController.isActive = !(state?.animationController.isActive ?? false)
        
        if (state?.animationController.isActive)! {
            toggleAnimationButton.image = NSImage(named: "NSTouchBarRecordStopTemplate")
            toggleAnimationButton.bezelColor = .systemRed
        }
        else {
            toggleAnimationButton.image = NSImage(named: "NSTouchBarPlayTemplate")
            toggleAnimationButton.bezelColor = .systemGreen
        }
    }
}
