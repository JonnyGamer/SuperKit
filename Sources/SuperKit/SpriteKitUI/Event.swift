//
//  Event.swift
//  SpriteKitJSONTesting
//
//  Created by Jonathan Pappas on 8/18/23.
//

import Foundation
import SpriteKit

public enum Property: String, Codable {
    case whenTapped
    case whenDragged
    case whenReleased
    case whenCancelled
    case whenKeyPressed
    case whenKeyReleased
    case update
    case whenSelected // only one object can be selected lol // perhaps add whenDeselected
    case whenDeselected
}

public class Event: Then {
    public var x: Double = 0.0
    public var y: Double = 0.0
    public var dx: Double = 0.0
    public var dy: Double = 0.0
    public var keyPressed: Key = .unknown
    public var keyReleased: Key = .unknown
    public var tracker: Tracker = .init()
}

extension NSEvent {
    var event: Event {
        let e = Event()
        let loc = location(in: trueScene)
        e.x = loc.x
        e.y = loc.y
        return e
    }
}

public class Tracker {
    var keysPressed: [Key] = []
    var keysPressedNodes: [Node] = []
    var keysReleasedNodes: [Node] = []
    var nodesTouching: [Node] = []
    var nodesReleased: [Node] = []
    var updateNodes: [Node] = []
    var location: CGPoint = .zero
    var editingNode: Node?
    var inputNode: Inputable?
}
