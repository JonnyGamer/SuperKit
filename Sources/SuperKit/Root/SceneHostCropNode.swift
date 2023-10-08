//
//  SceneHostCropNode.swift
//  PappasSpriteKitUITesting
//
//  Created by Jonathan Pappas on 8/18/23.
//

import SpriteKit

class SceneHost: SKCropNode {
    
    var options = Options()
    
    var curr: Scene
//    let backgroundColor: Color {
//        get { Color }
//        set {}
//    }
    
    var hostNode = SKNode()
    var root = _root//Node(id: -1)
    var hide = _hide//Node(id: -2)
    
    var followingNode: SKNode?
    
    let bg: SKSpriteNode = SKSpriteNode.init(color: .darkGray, size: .screenSize).then({
        $0.zPosition = -.infinity
        $0.position = .midPoint
    })
    
    func update() {
        if let f = followingNode {
            if !hostNode.hasActions() {
                hostNode.position = f.position.negative()
            }
            if options.cameraTrackingDelay > 0 {
                hostNode.run(.move(to: f.position.negative(), duration: options.cameraTrackingDelay))
            } else {
                hostNode.position = f.position.negative()
            }
        }
        curr.update?()
    }
    
    init(hosting: Scene) {
        self.curr = hosting
        super.init()
        
        let scrop = SKSpriteNode.init(color: .white, size: .screenSize)
        maskNode = scrop
        scrop.position = .midPoint
        //scrop.run(.moveBy(x: 0, y: 100, duration: 1))
        
        addChild(hostNode)
        hostNode.addChild(root.__node__)
        hostNode.addChild(hide.__node__)
        totalNodes += root.__node__.totalChildrenRecursive()
        totalNodes += hide.__node__.totalChildrenRecursive()
        
        addChild(bg)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
