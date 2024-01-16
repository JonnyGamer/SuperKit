//
//  Scene.swift
//  PappasSpriteKitUITesting
//
//  Created by Jonathan Pappas on 8/18/23.
//

import Foundation
import SpriteKit

@objc public protocol Scene {
    @objc optional func began()
    @objc optional func update()
    @objc optional func keyPressed(key: Key)
    @objc optional func keyReleased(key: Key)
    @objc optional func collision()
    @objc optional func touchBegan(x: Double, y: Double)
    @objc optional func touchMoved(dx: Double, dy: Double)
    @objc optional func touchEnded()
}

//public extension Scene {
//    func presentScene<T: Scene>(_ someScene: @escaping () -> T) {
//        presentScene(transition: .none, someScene)
//    }
//    func presentScene<T: Scene>(transition: SceneTransition, _ someScene: @escaping () -> T) {
//        trueScene.presentScene(transition: transition, someScene)
//    }
//}

public func topWall() {
    let topWall = PhysicsBox(width: 1600, height: 10)
    topWall.minX = 0
    topWall.minY = 1000
    topWall.stationary = true
}
public func bottomWall() {
    let topWall = PhysicsBox(width: 1600, height: 10)
    topWall.minX = 0
    topWall.maxY = 0
    topWall.stationary = true
}

public func leftWall() {
    let leftWall = PhysicsBox(width: 1, height: 1000)
    leftWall.minX = 0
    leftWall.minY = 0
    leftWall.stationary = true
}
public func rightWall() {
    let rightWall = PhysicsBox(width: 1, height: 1000)
    rightWall.maxX = 1600
    rightWall.minY = 0
    rightWall.stationary = true
}



//public extension Scene {
public var collidedNodes: [Node] { return trueScene.collidedNodes }
public var keysPressed: [Key] { return trueScene.keysPressed }
public var nodesTouching: [Node] { return trueScene.nodesTouching }
//    func add(_ child: Node) { // <T: Node>
//        if child.__node__.parent != nil {
//            print("Warning: Attempting to add a child which already has a parent.")
//            return
//        }
//        child.parentID = OptionalID(-1)
//
//        trueScene.curr.hostNode.addChild(child.__node__)
//    }
//    func add(_ child: SKNode) {
//        if child.parent != nil {
//            print("Warning: Attempting to add a child which already has a parent.")
//            return
//        }
//        trueScene.curr.hostNode.addChild(child)
//    }
public func holdingKey(_ key: Key) -> Bool {
    return keysPressed.contains(key)
}
public func cameraFollows(_ child: Node) {
    trueScene.curr.followingNode = nil
    trueScene.curr.hostNode.removeAllActions()
    trueScene.curr.followingNode = child.__node__
}
public func cameraStopFollowing() {
    trueScene.curr.followingNode = nil
}
public var backgroundColor: Color {
    get { trueScene.curr.bg.color.color() }
    set { trueScene.curr.bg.color = newValue.nsColor }
}
public var options: Options {
    get { trueScene.curr.options }
    set { trueScene.curr.options = newValue }
}
//public func iAmTouching<T: Node>(_ some: T) -> Bool {
//    return trueScene.nodesTouching.contains { some.__node__ === $0 }
//}
//public func iStoppedTouching<T: Node>(_ some: T) -> Bool {
//    return trueScene.nodesReleased.contains { some.__node__ === $0 }
//}
public func clearJSON() {
    Everything.clear()
}
public func encode() {
    print(_encode(Container(root)))
}
    
public func decode(jsonString: String) {
    Everything.decode(jsonString)
}
    
//    @discardableResult
//    func decode(_ fileName: String) -> [Node] {
//        
//        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
//            do {
//                let data = try Data(contentsOf: url)
//                //let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
//                // Process your JSON object here
//                let jsonDecoder = JSONDecoder()
//                let container = try jsonDecoder.decode(Container.self, from: data)
//                return Everything.decode(container)// decodeFrom(container)
//            } catch {
//                print("Error decoding or reading JSON: \(error)")
//            }
//        } else {
//            print("JSON file not found in the bundle.")
//        }
//        fatalError()
//    }
    
//}
