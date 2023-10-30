//
//  Image.swift
//  PappasSpriteKitUITesting
//
//  Created by Jonathan Pappas on 8/18/23.
//

import SpriteKit

/// Edit this to do some interesting things lol
public var defaultScales: [String : Double] = [:]

open class Image: Node, Size, Colorable {
    public override var __node__: SKNode { __sprite__ }
    private(set) public var __sprite__: SKSpriteNode!
    func emptySprite() { __sprite__.texture = SKSpriteNode(color: .red, size: .hundred).texture }
    override var type: NodeTypes { .Image }
    
    @discardableResult
    public init(_ named: String,_ execute: (() -> ())? = nil) {
        __sprite__ = SKSpriteNode.init()
        image = named
        super.init()
        update()
        s(execute)
    }
    
    fileprivate init(_ fromTexture: SKTexture) {
        __sprite__ = SKSpriteNode.init(texture: fromTexture)
        super.init(DONTSAVE: true)
    }
    
    fileprivate init(_ fromTexture: SKTextureAtlas) {
        __sprite__ = SKSpriteNode.init(texture: fromTexture.textureNamed(fromTexture.textureNames[0]))
        super.init(DONTSAVE: true)
    }
    
    @discardableResult
    private func _edit<T>(_ newValue: T,_ edit: (() -> ())?, _ path: ReferenceWritableKeyPath<Image, T>...) -> Self {
        // Assign the value. However, determine if this is `NOW` or a `DELAYED` action
        for i in path {
            self[keyPath: i] = newValue
        }
        s(edit) // post edit closure
        return self
    }
    
    private var _width: Double? = nil
    public var width: Double {
        get { _width ?? trueSize.width }
        set {
            _width = newValue == trueSize.width ? nil : newValue
            __sprite__.size.width = newValue
        }
    }
    /// The height of the width.
    @discardableResult public func width(_ newValue: Double, edit: (() -> ())? = nil) -> Self { _edit(newValue, edit, \.width) }
    
    func matchRatioPreserveHeight() {
        let realRatio = trueSize.width / trueSize.height
        width = height * realRatio
    }
    func matchRatioPreserveWidth() {
        let realRatio = trueSize.height / trueSize.width
        height = width * realRatio
    }
    
    private var _height: Double? = nil
    public var height: Double {
        get { _height ?? trueSize.height }
        set {
            _height = newValue == trueSize.height ? nil : newValue
            __sprite__.size.height = newValue
        }
    }
    /// The height of the image.
    @discardableResult public func height(_ newValue: Double, edit: (() -> ())? = nil) -> Self { _edit(newValue, edit, \.height) }
    
    var _color: _Color { get { color.c() } set { color = newValue.c() } }
    public var color: Color = .white { willSet { __sprite__.color = newValue.nsColor } }
    /// The color of the image. Remember to set `colorPercentage` to 100.
    @discardableResult public func color(_ newValue: Color, edit: (() -> ())? = nil) -> Self { _edit(newValue, edit, \.color) }
    
    public var colorPercentage: Double = 0 { willSet { __sprite__.colorBlendFactor = newValue / 100 } }
    /// The color percentage applied to the image.
    @discardableResult public func colorPercentage(_ newValue: Double, edit: (() -> ())? = nil) -> Self { _edit(newValue, edit, \.colorPercentage) }
    
    var trueSize: CGSize = .zero
    public var image: String = "" { willSet {
        node.defaultScale = defaultScales[newValue] ?? 1.0
        __sprite__.texture = SKTexture.init(imageNamed: newValue).then({ $0.filteringMode = .nearest })
        updateImageSize()
    } }
    func updateImageSize() {
        trueSize = __sprite__.texture?.size() ?? .zero
        width = width.d
        height = height.d
    }
    /// The x-coordinate.
    @discardableResult public func image(_ newValue: String, edit: (() -> ())? = nil) -> Self { _edit(newValue, edit, \.image) }
    
    
    private func update() {
        image = image.d
        color = color.d
        colorPercentage = colorPercentage.d
        width = width.d
        height = height.d
        //lockedRatio = lockedRatio.d
    }
    
    private enum CodingKeys: String, CodingKey {
        case width, height, color, image, colorPercentage
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let w = _width { try container.encode(w, forKey: .width) }
        if let h = _height { try container.encode(h, forKey: .height) }
        if color != .white { try container.encode(self.color, forKey: .color) }
        if colorPercentage != 0 { try container.encode(self.colorPercentage, forKey: .colorPercentage) }
        if image != "" { try container.encode(self.image, forKey: .image) }
        //if lockedRatio { try container.encode(self.lockedRatio, forKey: .lockedRatio) }
    }
    
    required public init(from decoder: Decoder) throws {
        __sprite__ = SKSpriteNode.init(color: .white, size: .zero)
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.color = try container.decodeIfPresent(Color.self, forKey: .color) ?? .white
        self.colorPercentage = try container.decodeIfPresent(Double.self, forKey: .colorPercentage) ?? 0
        self.image = try container.decodeIfPresent(String.self, forKey: .image) ?? ""
        self._width = try container.decodeIfPresent(Double.self, forKey: .width)
        self._height = try container.decodeIfPresent(Double.self, forKey: .height)
        //self.lockedRatio = try container.decodeIfPresent(Bool.self, forKey: .lockedRatio) ?? false
        
        update()
    }
}


class _Image: Image {
    
    override var image: String {
        get { "@custom" }
        set {  }
    }
    
    override init(_ from: SKTexture) {
        super.init(from)
    }
    
//    init(atlas: String) {
//        super.init(SKTextureAtlas.init(named: atlas))
//        //super.init(from)
//    }
    
    init(_ from: NSImage) {
        super.init(SKTexture.init(image: from))
    }
    
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
}
