//
//  File.swift
//
//
//  Created by Jonathan Pappas on 8/14/23.
//

import SpriteKit

public func presentScene<T: Scene>(_ someScene: @escaping () -> T) {
    presentScene(transition: .none, someScene)
}
public func presentScene<T: Scene>(transition: SceneTransition, _ someScene: @escaping () -> T) {
    trueScene.presentScene(transition: transition, someScene)
}

public enum SceneTransition {
    public enum Direction: Int {
        case left, right, up, down
        var d: CGVector {
            switch self {
            case .left: return .init(dx: -1600, dy: 0)
            case .right: return .init(dx: 1600, dy: 0)
            case .down: return .init(dx: 0, dy: -1000)
            case .up: return .init(dx: 0, dy: 1000)
            }
        }
    }
    case none
    case push(Direction)
    case slide(Direction)
    /// This one is broken for some reason
    case fadeTogether
    case fade(Color)
    case slideColor(Color, Direction)
    /// This one is a tiny bit broken
    case pushColor(Color, Direction)
}

extension RootScene {
    
    func presentScene<T: Scene>(first: Bool = false, transition: SceneTransition, _ sceneClosure: () -> T) {
        if !first {
            clearJSON()
            stack.removeAll()
            _root = Node(id: -1)
            _hide = Node(id: -2)
        }
        let curr = curr
        self.curr = nil
        let someScene = sceneClosure()
        let duration: Double = 0.5//1.0
        
        // Remove old scene, and properties
        let centerPosition = CGPoint.zero// CGPoint.init(x: self.size.width/2, y: self.size.height/2)
        tracker = Tracker()
        transitioning = true
        physicsWorld.removeAllJoints()
        totalNodes += 5
        
        switch transition {
        case .none:
            curr?.removeFromParentRecursive()
            self.curr = SceneHost.init(hosting: someScene)
            addChild(self.curr)
            self.curr.position = centerPosition
            self.curr.curr.began?()
            transitioning = false
            
        case .push(let x):
            let dpoint = x.d
            let moveByAction = SKAction.move(by: dpoint, duration: duration).easeInOut()
            
            guard let oldCurr = curr else { return }
            outgoingCurr = oldCurr
            oldCurr.run(moveByAction) {
                oldCurr.removeFromParentRecursive()
                self.outgoingCurr = nil
            }
            
            let newCurr = SceneHost.init(hosting: someScene)
            self.curr = newCurr
            incomingCurr = newCurr
            addChild(newCurr)
            newCurr.position = centerPosition
            newCurr.position.x -= dpoint.dx
            newCurr.position.y -= dpoint.dy
            newCurr.run(moveByAction) {
                self.incomingCurr = nil
                self.transitioning = false
            }
            newCurr.curr.began?()
        
        case .slide(let x):
            let dpoint = x.d
            let moveByAction = SKAction.move(by: dpoint, duration: duration).easeInOut()
            
            guard let oldCurr = curr else { return }
            outgoingCurr = oldCurr
            oldCurr.run(.wait(forDuration: duration)) {
                oldCurr.removeFromParentRecursive()
                self.outgoingCurr = nil
            }
            
            let newCurr = SceneHost.init(hosting: someScene)
            self.curr = newCurr
            incomingCurr = newCurr
            addChild(newCurr)
            newCurr.position = centerPosition
            newCurr.position.x -= dpoint.dx
            newCurr.position.y -= dpoint.dy
            newCurr.run(moveByAction) {
                self.incomingCurr = nil
                self.transitioning = false
            }
            newCurr.curr.began?()
        
        case .fadeTogether:
            guard let oldCurr = curr else { return }
            outgoingCurr = oldCurr
            oldCurr.maskNode?.run(.fadeAlpha(to: 0, duration: duration).easeInOut()) {
                oldCurr.removeFromParentRecursive()
                self.outgoingCurr = nil
            }
            
            let newCurr = SceneHost.init(hosting: someScene)
            self.curr = newCurr
            incomingCurr = newCurr
            addChild(newCurr)
            newCurr.position = centerPosition
            //newCurr.hostNode.alpha = 0
            newCurr.maskNode?.alpha = 0
            newCurr.maskNode?.run(.fadeAlpha(to: 1.0, duration: duration).easeInOut()) {
                self.incomingCurr = nil
                self.transitioning = false
            }
            newCurr.curr.began?()
            
        case let .fade(c):
            
            let box = SKSpriteNode.init(color: c.nsColor, size: .screenSize)
            addChild(box)
            box.position = .midPoint
            box.alpha = 0
            
            guard let oldCurr = curr else { return }
            outgoingCurr = oldCurr
            box.run(.fadeAlpha(to: 1.0, duration: duration/2).easeInOut()) {
                oldCurr.removeFromParentRecursive()
                self.outgoingCurr = nil
                
                let newCurr = SceneHost.init(hosting: someScene)
                self.curr = newCurr
                self.incomingCurr = newCurr
                self.addChild(newCurr)
                newCurr.position = centerPosition
                //newCurr.hostNode.alpha = 0
                box.run(.sequence([.wait(forDuration: duration/2), .fadeAlpha(to: 0.0, duration: duration/2).easeInOut()])) {
                    self.incomingCurr = nil
                    self.transitioning = false
                    box.removeFromParentRecursive()
                }
                newCurr.curr.began?()
                
            }
        
        case let .pushColor(c, x):
            
            let dpoint = x.d
            let moveByAction = SKAction.move(by: dpoint, duration: duration).easeInOut()
            
            
            let box = SKSpriteNode.init(color: c.nsColor, size: .screenSize)
            addChild(box)
            box.position = .midPoint
            box.position.x -= dpoint.dx
            box.position.y -= dpoint.dy
            
            
            guard let oldCurr = curr else { return }
            outgoingCurr = oldCurr
            oldCurr.run(moveByAction) {
                oldCurr.removeFromParentRecursive()
                self.outgoingCurr = nil
            }
            box.run(moveByAction) {
                
                
                let newCurr = SceneHost.init(hosting: someScene)
                self.curr = newCurr
                self.incomingCurr = newCurr
                self.addChild(newCurr)
                newCurr.position = centerPosition
                newCurr.position.x -= dpoint.dx
                newCurr.position.y -= dpoint.dy
                newCurr.curr.began?()
                
                newCurr.run(moveByAction) {
                    self.incomingCurr = nil
                    self.transitioning = false
                }
                box.run(moveByAction) {
                    box.removeFromParent()
                }
                
            }
            
        default:
            break
            
        }
        
    }
    
}
