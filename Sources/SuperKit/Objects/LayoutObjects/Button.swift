//
//  Button.swift
//  PappasSpriteKitUITesting
//
//  Created by Jonathan Pappas on 8/24/23.
//

import SpriteKit

public class Button: Node, Size, Colorable {
    
    //@objc public override var __node__: SKNode { __button__ }
    private(set) public var __button__: SKShapeNode!
    override var type: NodeTypes { .Button }
    
    @discardableResult
    private func _edit<T>(_ newValue: T,_ edit: (() -> ())?, _ path: ReferenceWritableKeyPath<Button, T>...) -> Self {
        for i in path { self[keyPath: i] = newValue }; return s(edit)
    }
    
    var _color: _Color { get { color.c() } set { color = newValue.c() } }
    public var color: Color = .white { willSet {
        __button__.fillColor = newValue.nsColor
        __button__.strokeColor = newValue.nsColor
        if outline {
            __button__.strokeColor = .black
        } else {
            __button__.strokeColor = newValue.nsColor
        }
    } }
    /// The color of the box.
    @discardableResult public func color(_ newValue: Color, edit: (() -> ())? = nil) -> Self { _edit(newValue, edit, \.color) }
    
    var regularColor: Color = .redSelection
    var pressedColor: Color = .blue
    var outline: Bool = false { didSet { color = color.d } }
    public var width: Double
    public var height: Double
    public var corner: Double
    var __buttonWindow__: Window!
    
    @discardableResult
    public init(width: Double, height: Double, corner: Double? = nil,_ execute: (() -> ())? = nil) {
        let corner = corner ?? (min(width, height))/10
        self.__button__ = SKShapeNode.init(rectOf: .ratio(width, height), cornerRadius: corner)
        self.width = width
        self.height = height
        self.corner = corner
        
        super.init()
        
        let copped = __button__.copied
        copped.fillColor = .black
        copped.strokeColor = .clear
        copped.alpha = 0.1
        copped.position.y -= 10
        __node__.addChild(copped)
        registerAsButton()
        
        self.__node__.addChild(__button__)
        
        self.__buttonWindow__ = Window.init(width: width, height: height) { this.color = .clear }
        self.__buttonWindow__.remove()
        super.add(__buttonWindow__)
        
        s(execute)
        update()
        __buttonWindow__.keepInsideWindow()
    }
    
    public override func add(_ child: Node) {
        __buttonWindow__.add(child)
    }
    
    private func pressed() {
        __button__.run(.moveBy(x: 0, y: -10, duration: 0.1))
        __buttonWindow__.__node__.run(.moveBy(x: 0, y: -10, duration: 0.1))
        __button__.run(.color(self, from: regularColor, to: pressedColor, duration: 0.1, colorize: \.color))
    }
    
    private func released() {
        __button__.run(.moveBy(x: 0, y: 10, duration: 0.1))
        __buttonWindow__.__node__.run(.moveBy(x: 0, y: 10, duration: 0.1))
        __button__.run(.color(self, from: pressedColor, to: regularColor, duration: 0.1, colorize: \.color))
    }
    
    func registerAsButton() {
        whenTapped {
            self.pressed()
        }
        whenReleased {
            self.released()
        }
        whenCancelled {
            self.released()
        }
    }
    
    
    private func update() {
        width = width.d
        height = height.d
        color = regularColor.d
        corner = corner.d
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
