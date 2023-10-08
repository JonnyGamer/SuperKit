//
//  HStack.swift
//  PappasSpriteKitUITesting
//
//  Created by Jonathan Pappas on 8/22/23.
//

import Foundation

public class HStack: Node { //Size
    
    override var type: NodeTypes { .HStack }
    
    @discardableResult
    public override init(_ execute: (() -> ())? = nil) {
        super.init(execute)
        update()
    }
    
    @discardableResult
    private func _edit<T>(_ newValue: T,_ edit: (() -> ())?, _ path: ReferenceWritableKeyPath<HStack, T>...) -> Self {
        // Assign the value. However, determine if this is `NOW` or a `DELAYED` action
        for i in path {
            self[keyPath: i] = newValue
        }
        s(edit) // post edit closure
        return self
    }
    
    public var alignment: Vertical = .center { willSet { if alignment != newValue { updateAlignment() } } }
    /// The width of the box.
    @discardableResult public func alignment(_ newValue: Vertical, edit: (() -> ())? = nil) -> Self { _edit(newValue, edit, \.alignment) }
    
    public var spacing: Double = 0.0 { willSet { if spacing != newValue { updateAlignment() } } }
    /// The width of the box.
    @discardableResult public func spacing(_ newValue: Double, edit: (() -> ())? = nil) -> Self { _edit(newValue, edit, \.spacing) }
    
    //public var width: Double
    //public var height: Double
    
    private func update() {
        alignment = alignment.d
        spacing = spacing.d
        updateAlignment()
    }
    
    func updateAlignment() {
        var xPosition: Double = 0
        for i in children {
            i.__node__.anchorAt(.init(x: xPosition, y: 0), anchor: .init(x: 0, y: alignment.anchorY()))
            xPosition = i.__node__.calculateAccumulatedFrame().maxX
            xPosition += spacing
        }
        let size = __node__.calculateAccumulatedFrame()
        for i in children {
            i.x -= size.width/2
        }
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
        self.alignment = try container.decodeIfPresent(Vertical.self, forKey: .alignment) ?? .center
        self.spacing = try container.decodeIfPresent(Double.self, forKey: .spacing) ?? 0
        
        update()
    }
    
}
