//
//  File.swift
//
//
//  Created by Jonathan Pappas on 8/14/23.
//

import Foundation
import SpriteKit

@available(macOS 10.11, *)
var trueScene: RootScene! // public
@available(macOS 10.11, *)
var currentScene: Scene! // public
var width: Double { Double(trueScene?.size.width ?? 1600) }
var height: Double { Double(trueScene?.size.height ?? 1000) }

class RootScene: SKScene, SKPhysicsContactDelegate {
    
    var curr: SceneHost!
    // var magicCamera = SKCameraNode()
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        trueScene = self
        backgroundColor = .black
        presentScene(first: true, transition: .none) { currentScene }
    }
    
    // Scene Update amidst Transitioning
    var outgoingCurr: SceneHost?
    var pauseOutgoingCurr: Bool = false
    var incomingCurr: SceneHost?
    var pauseIncomingCurr: Bool = false
    var transitioning: Bool = false
    
    var updateNodes: [Node] { get { tracker.updateNodes } set { tracker.updateNodes = newValue } }
    override func didFinishUpdate() {
        if !transitioning {
            curr.update()
        }
        if !pauseIncomingCurr {
            incomingCurr?.update()
        }
        if !pauseOutgoingCurr {
            outgoingCurr?.update()
        }
        updateNodes.update(Event())
    }
    
    // Key Functionality
     
    // var location: CGPoint = .zero
    var keysPressed: [Key] { get { tracker.keysPressed } set { tracker.keysPressed = newValue } }
    var keysPressedNodes: [Node] { get { tracker.keysPressedNodes } set { tracker.keysPressedNodes = newValue } }
    var keysReleasedNodes: [Node] { get { tracker.keysReleasedNodes } set { tracker.keysReleasedNodes = newValue } }
    override func keyDown(with event: NSEvent) {
        if transitioning { return }
        if event.isARepeat { return }
        let key = Key.init(rawValue: event.keyCode) ?? .unknown
        keysPressed.append(key)
        curr.curr.keyPressed?(key: key)
        keysPressedNodes.keyPressed(Event().then({ $0.keyPressed = key }))
        
        updateTextEditor(tracker.inputNode, event: event)
    }
    override func keyUp(with event: NSEvent) {
        if transitioning { return }
        let key = Key.init(rawValue: event.keyCode) ?? .unknown
        if keysPressed.contains(key) {
            keysPressed.removeAll(where: { $0 == key })
            curr.curr.keyReleased?(key: key)
            keysReleasedNodes.keyReleased(Event().then({ $0.keyReleased = key }))
        }
    }
    
    
    func isPoint(_ point: CGPoint, insideNode node: SKNode) -> Bool {
        let pointInNodeSpace = node.convert(point, from: self)
        return node.contains(pointInNodeSpace)
    }
    
    var tracker = Tracker()
    
    // Touching Functionality
    var nodesTouching: [Node] { get { tracker.nodesTouching } set { tracker.nodesTouching = newValue } }
    var nodesReleased: [Node] { get { tracker.nodesReleased } set { tracker.nodesReleased = newValue } }
    var location: CGPoint { get { tracker.location } set { tracker.location = newValue } }
    override func mouseDown(with event: NSEvent) {
        if transitioning { return }
        location = event.location(in: self)
        //nodesTouching = nodes(at: location)
        nodesTouching = nodes(at: location).sorted(by: { $0.zPosition > $1.zPosition }).filter({ $0.containsPoint(location) }).map({ Everything.find($0) }).compactMap()
        curr.curr.touchBegan?(x: location.x, y: location.y)
        
        let oldEditingNode = tracker.editingNode
        tracker.editingNode = nodesTouching.first(where: { $0.editable })//nodesTouching.sorted(by: { $0.layer > $1.layer }).first(where: { $0.editable })
        if oldEditingNode !== tracker.editingNode {
            oldEditingNode?.deselect() // Event()
            tracker.editingNode?.select() // Event()
        }
        
        this: if let inputNode = tracker.editingNode as? Inputable {
            if tracker.inputNode === inputNode { break this }
            tracker.inputNode?.deselect()
            tracker.inputNode = inputNode
            tracker.inputNode?.select()
        } else {
            tracker.inputNode?.deselect()
            tracker.inputNode = nil
        }
        //nodesTouching.first(where: { $0.properties[.whenTapped] != nil })?.tapped(Event().then({ $0.x = location.x; $0.y = location.y }))
        nodesTouching.tapped(Event().then({ $0.tracker = tracker }))
    }
    override func mouseDragged(with event: NSEvent) {
        if transitioning { return }
        let newLocation = event.location(in: self)
        let dx = newLocation.x - location.x
        let dy = newLocation.y - location.y
        location = newLocation
        curr.curr.touchMoved?(dx: dx, dy: dy)
        
        nodesTouching.sort(by: { $0.layer > $1.layer })
        nodesTouching.first(where: { $0.properties[.whenDragged] != nil })?.dragged(Event().then({ $0.dx = dx; $0.dy = dy; $0.x = location.x; $0.y = location.y }))
        //nodesTouching.dragged(Event().then({ $0.dx = dx; $0.dy = dy }))
    }
    override func mouseUp(with event: NSEvent) {
        if transitioning { return }
        nodesReleased = nodesTouching
        
        let nodesEndedOn = nodesTouching.filter({ $0.__node__.containsPoint(location) })
        let nodesEndedOff = nodesTouching.filter({ !$0.__node__.containsPoint(location) })
        
        nodesTouching.removeAll()
        curr.curr.touchEnded?()
        nodesReleased.removeAll()
        
        nodesEndedOn.released(Event())// touchEnded()
        nodesEndedOff.cancelled(Event())// .touchCancelled()
        
    }

    // Collision Fest :)
    func didBegin(_ contact: SKPhysicsContact) {
        curr.curr.collision?()
    }
    
}

public class Options {
    public var cameraTrackingDelay: Double = 0
    public var showsFPS = false {
        willSet { setFrameRateVisibility(newValue) }// trueScene.view?.showsFPS = newValue }
    }
    public var showsNodeCount = false {
        willSet { setNodeCountVisibility(newValue) }// trueScene.view?.showsFPS = newValue
    }
    public var showsPhysics = false {
        willSet { setPhysicsVisibility(newValue) }// trueScene.view?.showsFPS = newValue
    }
    // var cameraTracksRotation: Bool = true
    // fileprivate var _resetCameraRotation = false
    // func resetCameraRotation() { _resetCameraRotation = true }
}
