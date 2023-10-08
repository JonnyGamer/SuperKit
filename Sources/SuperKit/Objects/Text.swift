//
//  Text.swift
//  PappasSpriteKitUITesting
//
//  Created by Jonathan Pappas on 8/22/23.
//

import SpriteKit

public class Text: Node, Colorable {
    @objc public override var __node__: SKNode { __text__ }
    private(set) public var __text__: SKLabelNode!
    override var type: NodeTypes { .Text }
    
    @discardableResult
    public init(_ text: String,_ execute: (() -> ())? = nil) {
        __text__ = SKLabelNode.init(text: text)
        self.text = text
        super.init(execute)
        update()
    }
    
    @discardableResult
    private func _edit<T>(_ newValue: T,_ edit: (() -> ())?, _ path: ReferenceWritableKeyPath<Text, T>...) -> Self {
        // Assign the value. However, determine if this is `NOW` or a `DELAYED` action
        for i in path {
            self[keyPath: i] = newValue
        }
        s(edit) // post edit closure
        return self
    }
    
    public var text: String = "" { willSet { __text__.text = newValue } }
    /// The width of the box.
    @discardableResult public func text(_ newValue: String, edit: (() -> ())? = nil) -> Self { _edit(newValue, edit, \.text) }
    
    var _color: _Color { get { color.c() } set { color = newValue.c() } }
    public var color: Color = .black { willSet { __text__.fontColor = newValue.nsColor } }
    /// The color of the box.
    @discardableResult public func color(_ newValue: Color, edit: (() -> ())? = nil) -> Self { _edit(newValue, edit, \.color) }
    
    public var fontName: FontList = .Helvetica { willSet { __text__.fontName = newValue.rawValue } }
    /// The color of the box.
    @discardableResult public func fontName(_ newValue: FontList, edit: (() -> ())? = nil) -> Self { _edit(newValue, edit, \.fontName) }
    
    
    private func update() {
        text = text.d
        color = color.d
        fontName = fontName.d
    }
    
    private enum CodingKeys: String, CodingKey {
        case text, color, fontName
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        if text != "" { try container.encode(self.text, forKey: .text) }
        if color != .black { try container.encode(self.color, forKey: .color) }
        if fontName != .Helvetica { try container.encode(self.fontName, forKey: .fontName) }
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let text = try container.decodeIfPresent(String.self, forKey: .text) ?? ""
        __text__ = SKLabelNode.init(text: text)
        
        try super.init(from: decoder)
        
        self.text = text
        self.color = try container.decodeIfPresent(Color.self, forKey: .color) ?? .black
        self.fontName = try container.decodeIfPresent(FontList.self, forKey: .fontName) ?? .Helvetica
        
        update()
    }
}

public enum FontList: String, Codable {
    case Helvetica, SFProRounded = "SF Pro Rounded"
}

public enum Vertical: String, Codable {
    case top, bottom, center, baseline
    func verticalAlignmentMode() -> SKLabelVerticalAlignmentMode {
        switch self {
        case .top: return .top
        case .bottom: return .bottom
        case .center: return .center
        case .baseline: return .baseline
        }
    }
    func anchorY() -> Double {
        switch self {
        case .top: return 1
        case .bottom: return 0
        case .center: return 0.5
        case .baseline: return 0
        }
    }
}
public enum Horizontal: String, Codable {
    case left, right, center
    func horitzonalAlignmentMode() -> SKLabelHorizontalAlignmentMode {
        switch self {
        case .left: return .left
        case .right: return .right
        case .center: return .center
        }
    }
    func anchorX() -> Double {
        switch self {
        case .left: return 0
        case .right: return 1
        case .center: return 0.5
        }
    }
}
