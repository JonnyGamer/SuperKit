//
//  RoundWindow.swift
//  PappasSpriteKitUITesting
//
//  Created by Jonathan Pappas on 8/24/23.
//

import SpriteKit

class RoundWindow: Node, Size, Colorable {
    
    override var type: NodeTypes { .RoundWindow }
    
    var __window__: SKShapeNode!
    var width: Double
    var height: Double
    
    @discardableResult
    private func _edit<T>(_ newValue: T,_ edit: (() -> ())?, _ path: ReferenceWritableKeyPath<RoundWindow, T>...) -> Self {
        for i in path { self[keyPath: i] = newValue }; return s(edit)
    }
    
    var _color: _Color { get { color.c() } set { color = newValue.c() } }
    public var color: Color = .white { willSet { __window__.fillColor = newValue.nsColor } }
    /// The color of the box.
    @discardableResult public func color(_ newValue: Color, edit: (() -> ())? = nil) -> Self { _edit(newValue, edit, \.color) }
    
    @discardableResult
    public init(width: Double, height: Double,_ execute: (() -> ())? = nil) {
        self.__window__ = SKShapeNode.init(rectOf: .ratio(width, height), cornerRadius: max(width, height)/10)
        self.__window__.strokeColor = .black
        self.__window__.lineWidth = max(width, height)/40
        self.width = width
        self.height = height
        super.init()
        __node__.addChild(__window__)
        
        s(execute)
        update()
    }
    
    private func update() {
        keepInsideWindow()
//        width = width.d
//        height = height.d
        color = color.d
//        corner = corner.d
    }
    func keepInsideWindow() {
        for i in children {
            i.__node__.keepInside(__window__.frame.size)
            i.__node__.centerAt(__window__.position)
        }
    }
    override func add(_ child: Node) {
        super.add(child)
        keepInsideWindow()
    }
    
    private enum CodingKeys: String, CodingKey {
        case width, height, corner, color, pressedColor, outline
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        if width != 0 { try container.encode(self.width, forKey: .width) }
//        if height != 0 { try container.encode(self.height, forKey: .height) }
//        if color != .white { try container.encode(self.color, forKey: .color) }
    }
    
    required public init(from decoder: Decoder) throws {
        fatalError()
//        __sprite__ = SKSpriteNode.init(color: .white, size: .zero)
//        try super.init(from: decoder)
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.width = try container.decodeIfPresent(Double.self, forKey: .width) ?? 0
//        self.height = try container.decodeIfPresent(Double.self, forKey: .height) ?? 0
//        self.color = try container.decodeIfPresent(Color.self, forKey: .color) ?? .white
//
//        update()
    }
    
    
}
