//
//  Circle.swift
//  PappasSpriteKitUITesting
//
//  Created by Jonathan Pappas on 8/22/23.
//

import SpriteKit
 
public class Circle: Node, Colorable {
    @objc public override var __node__: SKNode { __shape__ }
    private(set) public var __shape__: SKShapeNode!
    override var type: NodeTypes { .Circle }
    
    @discardableResult
    public init(radius: Double,_ execute: (() -> ())? = nil) {
        __shape__ = SKShapeNode.init(circleOfRadius: radius)
        self.radius = radius
        super.init(execute)
        update()
    }
    
    @discardableResult
    private func _edit<T>(_ newValue: T,_ edit: (() -> ())?, _ path: ReferenceWritableKeyPath<Circle, T>...) -> Self {
        // Assign the value. However, determine if this is `NOW` or a `DELAYED` action
        for i in path {
            self[keyPath: i] = newValue
        }
        s(edit) // post edit closure
        return self
    }
    
    private(set) public var radius: Double = 0 { willSet {  } }
    /// The width of the box.
    @discardableResult private func radius(_ newValue: Double, edit: (() -> ())? = nil) -> Self { _edit(newValue, edit, \.radius) }
    
    var _color: _Color { get { color.c() } set { color = newValue.c() } }
    public var color: Color = .white { willSet { __shape__.strokeColor = newValue.nsColor; __shape__.fillColor = newValue.nsColor } }
    /// The color of the box.
    @discardableResult public func color(_ newValue: Color, edit: (() -> ())? = nil) -> Self { _edit(newValue, edit, \.color) }
    
    
    private func update() {
        radius = radius.d
        color = color.d
    }
    
    private enum CodingKeys: String, CodingKey {
        case radius, color
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        if radius != 0 { try container.encode(self.radius, forKey: .radius) }
        if color != .white { try container.encode(self.color, forKey: .color) }
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let radius = try container.decodeIfPresent(Double.self, forKey: .radius) ?? 0
        __shape__ = SKShapeNode.init(circleOfRadius: radius)
        
        try super.init(from: decoder)
        
        self.radius = radius
        self.color = try container.decodeIfPresent(Color.self, forKey: .color) ?? .white
        
        update()
    }
}
