//
//  ViewController.swift
//  polygon-path-animation
//
//  Created by Yaroslav on 09/09/2019.
//  Copyright © 2019 Yaroslav. All rights reserved.
//

import Cocoa
import SpriteKit

class ViewController: NSViewController {
    
    var state: ApplicationState =  ApplicationState()
    
    
    @IBOutlet var skView: SKView!
    
    @IBOutlet var pathModeButton: NSButton!
    @IBOutlet var polygonModeButton: NSButton!
    
    @IBOutlet var toggleAnimationButton: NSButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let view = self.skView {
            let scene = Scene(size: CGSize(width: view.frame.width * 2, height: view.frame.height * 2))
            scene.state = state
            state.movingPath = MovingPath(scene: scene, lineWidth: 7, strokeColor: .blue, vertexColor: .orange, vertexRadius: 15, vertexPrefix: "p")
            state.polygonPath = PolygonPath(scene: scene, lineWidth: 3, strokeColor: .systemGreen, vertexColor: .systemYellow, vertexRadius: 7)
            
            view.ignoresSiblingOrder = true
            scene.scaleMode = .aspectFill
            
            view.presentScene(scene)
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func setPathMode(_ sender: Any) {
        pathModeButton.bezelColor = .systemBlue
        polygonModeButton.bezelColor = nil
        
        state.mode = .path
    }
    
    @IBAction func setPolygonMode(_ sender: Any) {
        pathModeButton.bezelColor = nil
        polygonModeButton.bezelColor = .systemBlue
        
        state.mode = .polygon
    }
    
    
    @IBAction func closePath(_ sender: Any) {
        state.getActivePath()?.finished = true
    }
    
    @IBAction func startAnimation(_ sender: Any) {
        if state.animationActive {
            state.movingPath?.resetState()
            state.polygonPath?.resetState()
        }
        
        state.animationActive = !state.animationActive
        
        if state.animationActive {
            toggleAnimationButton.image = NSImage(named: "NSTouchBarRecordStopTemplate")
            toggleAnimationButton.bezelColor = .systemRed
            
        }
        else {
            toggleAnimationButton.image = NSImage(named: "NSTouchBarPlayTemplate")
            toggleAnimationButton.bezelColor = .systemGreen
        }
    }
}

