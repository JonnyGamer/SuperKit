//
//  Window.swift
//  PappasSpriteKitUITesting
//
//  Created by Jonathan Pappas on 8/24/23.
//

import SpriteKit

class Window: Node, Size, Colorable {
    
    override var type: NodeTypes { .Window }
    
    var __window__: SKSpriteNode!
    var width: Double
    var height: Double
    
    @discardableResult
    private func _edit<T>(_ newValue: T,_ edit: (() -> ())?, _ path: ReferenceWritableKeyPath<Window, T>...) -> Self {
        for i in path { self[keyPath: i] = newValue }; return s(edit)
    }
    
    var _color: _Color { get { color.c() } set { color = newValue.c() } }
    public var color: Color = .white { willSet { __window__.color = newValue.nsColor } }
    /// The color of the box.
    @discardableResult public func color(_ newValue: Color, edit: (() -> ())? = nil) -> Self { _edit(newValue, edit, \.color) }
    
    @discardableResult
    public init(width: Double, height: Double,_ execute: (() -> ())? = nil) {
        self.__window__ = SKSpriteNode.init(color: .white, size: CGSize.init(width: width, height: height))
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
            i.__node__.keepInside(__window__.size)
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
//
//
//class _NodeKeepsInside: Node {
//    var keepInside: SKSpriteNode
//
//    init(_ keepInside: SKSpriteNode) {
//        self.keepInside = keepInside
//        super.init(DONTSAVE: true)
//    }
//
//    override func add(_ child: Node) {
//        super.add(child)
//        self.__node__.keepInside(keepInside.size)
//        self.__node__.centerAt(keepInside.position)
//    }
//
//
//    required public init(from decoder: Decoder) throws {
//        fatalError()
//    }
//}
