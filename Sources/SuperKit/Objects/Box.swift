//
//  Box.swift
//  PappasSpriteKitUITesting
//
//  Created by Jonathan Pappas on 8/18/23.
//

import SpriteKit

open class Box: Node, Size, Colorable {
    @objc public override var __node__: SKNode { __sprite__ }
    private(set) public var __sprite__: SKSpriteNode!
    override var type: NodeTypes { .Box }
    
    @discardableResult
    public init(width: Double, height: Double,_ execute: (() -> ())? = nil) {
        __sprite__ = SKSpriteNode.init(color: .white, size: .ratio(width, height))
        self.width = width
        self.height = height
        super.init()
        update()
        s(execute)
    }
    
    @discardableResult
    init(image: String,_ execute: (() -> ())? = nil) {
        __sprite__ = SKSpriteNode.init(imageNamed: image)
        self.width = __sprite__.size.width
        self.height = __sprite__.size.height
        super.init()
        update()
        s(execute)
    }
    
    @discardableResult
    private func _edit<T>(_ newValue: T,_ edit: (() -> ())?, _ path: ReferenceWritableKeyPath<Box, T>...) -> Self {
        for i in path { self[keyPath: i] = newValue }; return s(edit)
    }
    
    public var width: Double = 0 { willSet { __sprite__.size.width = newValue } }
    /// The width of the box.
    @discardableResult public func width(_ newValue: Double, edit: (() -> ())? = nil) -> Self { _edit(newValue, edit, \.width) }
    
    public var height: Double = 0 { willSet { __sprite__.size.height = newValue } }
    /// The height of the box.
    @discardableResult public func height(_ newValue: Double, edit: (() -> ())? = nil) -> Self { _edit(newValue, edit, \.height) }
    
    var _color: _Color { get { color.c() } set { color = newValue.c() } }
    public var color: Color = .white { willSet { __sprite__.color = newValue.nsColor } }
    /// The color of the box.
    @discardableResult public func color(_ newValue: Color, edit: (() -> ())? = nil) -> Self { _edit(newValue, edit, \.color) }
    
    
    private func update() {
        width = width.d
        height = height.d
        color = color.d
    }
    
    private enum CodingKeys: String, CodingKey {
        case width, height, color
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        if width != 0 { try container.encode(self.width, forKey: .width) }
        if height != 0 { try container.encode(self.height, forKey: .height) }
        if color != .white { try container.encode(self.color, forKey: .color) }
    }
    
    required public init(from decoder: Decoder) throws {
        __sprite__ = SKSpriteNode.init(color: .white, size: .zero)
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.width = try container.decodeIfPresent(Double.self, forKey: .width) ?? 0
        self.height = try container.decodeIfPresent(Double.self, forKey: .height) ?? 0
        self.color = try container.decodeIfPresent(Color.self, forKey: .color) ?? .white
        
        update()
    }
}
