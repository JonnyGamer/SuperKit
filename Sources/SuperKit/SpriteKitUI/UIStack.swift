//
//  UIStack.swift
//  SpriteKitJSONTesting
//
//  Created by Jonathan Pappas on 8/16/23.
//

import SpriteKit

var _root: Node = Node(id: -1)
var _hide: Node = Node(id: -2)
public var root: Node { trueScene?.curr?.root ?? _root }

var stack: [Node] = []

/// Make the node become a child of the scene, or the node currently in the spotlight
func addToStack(_ node: Node) {
    if let end = stack.last {
        end.add(node)
    } else {
        // Add to the RootScene
        root.add(node)
    }
}

var eventStack: [Event] = []
var event: Event { eventStack.last ?? Event() }
