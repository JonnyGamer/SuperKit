//
//  VStack.swift
//  PappasSpriteKitUITesting
//
//  Created by Jonathan Pappas on 8/22/23.
//

import Foundation

public class VStack: Node {
    
    override var type: NodeTypes { .VStack }
    
    @discardableResult
    public override init(_ execute: (() -> ())? = nil) {
        super.init(execute)
        update()
    }
    
    @discardableResult
    private func _edit<T>(_ newValue: T,_ edit: (() -> ())?, _ path: ReferenceWritableKeyPath<VStack, T>...) -> Self {
        // Assign the value. However, determine if this is `NOW` or a `DELAYED` action
        for i in path {
            self[keyPath: i] = newValue
        }
        s(edit) // post edit closure
        return self
    }
    
    public var alignment: Horizontal = .center { willSet { if alignment != newValue { updateAlignment() } } }
    /// The width of the box.
    @discardableResult public func alignment(_ newValue: Horizontal, edit: (() -> ())? = nil) -> Self { _edit(newValue, edit, \.alignment) }
    
    public var spacing: Double = 0.0 { willSet { if spacing != newValue { updateAlignment() } } }
    /// The width of the box.
    @discardableResult public func spacing(_ newValue: Double, edit: (() -> ())? = nil) -> Self { _edit(newValue, edit, \.spacing) }
    
    
    private func update() {
        alignment = alignment.d
        spacing = spacing.d
        updateAlignment()
    }
    
    func updateAlignment() {
        var yPosition: Double = 0
        for i in children {
            i.__node__.anchorAt(.init(x: 0, y: yPosition), anchor: .init(x: alignment.anchorX(), y: 1))
            yPosition = i.__node__.calculateAccumulatedFrame().minY
            yPosition -= spacing
        }
    }
    
    func removeChild(_ at: Int) {
        children[at].remove()
        //children.remove(at: at)
        //children.last?.remove()
        updateAlignment()
    }
    public func append(_ child: Node) {
        //add(child)
        updateAlignment()
    }
    public func insert(_ child: Node, at: Int) {
        //add(child)
        let ind = children.firstIndex(where: { $0 === child })!
        children.remove(at: ind)
        children.insert(child, at: at)
        //children
        updateAlignment()
    }
    
    private enum CodingKeys: String, CodingKey {
        case alignment, spacing
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        if alignment != .center { try container.encode(self.alignment, forKey: .alignment) }
        if spacing != 0 { try container.encode(self.spacing, forKey: .spacing) }
    }
    
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.alignment = try container.decodeIfPresent(Horizontal.self, forKey: .alignment) ?? .center
        self.spacing = try container.decodeIfPresent(Double.self, forKey: .spacing) ?? 0
        
        update()
    }
    
}
