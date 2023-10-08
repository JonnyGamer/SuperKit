//
//  SKNodeExtensions.swift
//  SpriteKitJSONTesting
//
//  Created by Jonathan Pappas on 8/18/23.
//

import SpriteKit

private var customNumberKey: Int = 0

extension SKNode {
    var referenceID: Int {
        get {
            return objc_getAssociatedObject(self, &customNumberKey) as? Int ?? (-10000)
        }
        set(newValue) {
            objc_setAssociatedObject(self, &customNumberKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

public extension Everything {
    static func find(_ node: SKNode) -> Node? {
        return get(node.referenceID)
    }
    func find(_ node: SKNode) -> Node? {
        return get(node.referenceID)
    }
}

extension Array where Element == SKNode {
    func nodes() -> [Node] {
        return map { Everything.get($0.referenceID) }.compactMap { $0 }
    }
}
extension Array where Element == Node {
    func tapped(_ event: Event) {
        for i in self {
            i.tapped(event)
        }
    }
    func dragged(_ event: Event) {
        for i in self {
            i.dragged(event)
        }
    }
    func released(_ event: Event) {
        for i in self {
            i.released(event)
        }
    }
    func cancelled(_ event: Event) {
        for i in self {
            i.cancelled(event)
        }
    }
    func keyPressed(_ event: Event) {
        for i in self {
            i.keyPressed(event)
        }
    }
    func keyReleased(_ event: Event) {
        for i in self {
            i.keyReleased(event)
        }
    }
    func update(_ event: Event) {
        for i in self {
            i.updateNode(event)
        }
    }
}
