//
//  Everything.swift
//  SpriteKitJSONTesting
//
//  Created by Jonathan Pappas on 8/17/23.
//

import Foundation
import SpriteKit

public class Everything {
    private static var o: Everything = Everything()
    
    // Completely Clear... Woah...
    public static func clear() {
        o = Everything()
    }
    public func clear() {
        nodes.removeAll()
        maximumId = 0
    }
    
    // Hide from JSON
    public static func hideAll() {
        o.hideAll()
    }
    public func hideAll() {
        for (_, n) in nodes {
            if n.id >= 0 {
                n.hidden = true
            }
        }
    }
    
    
    private var nodes: [Int : Node] = [:]
    var maximumId = 0
    
    public static func add(_ this: Node) {
        o.add(this)
        this.__node__.accessibilityLabel = "\(this.id)"
    }
    public func add(_ this: Node) {
        if nodes[this.id] == nil {
            nodes[this.id] = this
        } else {
            this.id = maxId()
        }
        maximumId = max(maximumId, this.id)
    }
    
    public static func get(_ thiss: SKNode?) -> Node? {
        guard let this = thiss,
              let ids = this.accessibilityLabel,
              let id = Int(ids) else { return nil }
        return o.get(id)
    }
    
    public static func get(_ this: Int) -> Node? {
        o.get(this)
    }
    public func get(_ this: Int) -> Node? {
        nodes[this]
    }
    
    public static func maxId() -> Int {
        o.maxId()
    }
    public func maxId() -> Int {
        let id = maximumId
        maximumId += 1
        return id
    }
    
    public func merge(_ with: Everything) {
        for (_, node) in with.nodes {
            add(node)
        }
        with.clear()
    }
    
    static func merge(_ with: Container) {
        let topNode = with.node
        
        let nodes = with.node.listChildrenRecursive()
        var f = true
        for node in nodes {
            if f { f = false; continue }
            if node.id < 0 { continue }
            add(node)
        }
        
        if topNode.id == -1 {
            // oof
            for i in with.node.children {
                i.moveTo(root)
                //root.add(i)
            }
        } else {
            root.add(with.node)
        }
        
    }
    
    public static func decode(jsonString: String) {
        let c: Container = _decode(jsonString)
        merge(c)
        //return Everything.decode(jsonString)
    }
    
    @discardableResult
    public static func decode(_ fileName: String) -> Bool { //  -> [Node]
        
        if let container = JSONFileManager.retrieveJSONDocument(filename: fileName) {
            merge(container)
            return true
        }
        return false
//        
//        
//        var fileName = fileName
//        if fileName.hasPrefix(".json") { fileName.removeLast(5) }
//        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
//            do {
//                let data = try Data(contentsOf: url)
//                //let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
//                // Process your JSON object here
//                let jsonDecoder = JSONDecoder()
//                let container = try jsonDecoder.decode(Container.self, from: data)
//                merge(container)
//                return
//                //return Everything.decodeFrom(container)
//            } catch {
//                print("Error decoding or reading JSON: \(error)")
//            }
//        } else {
//            print("JSON file not found in the bundle.")
//        }
//        fatalError()
    }
    
}


