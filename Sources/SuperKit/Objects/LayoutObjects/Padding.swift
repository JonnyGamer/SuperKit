//
//  Padding.swift
//  PappasSpriteKitUITesting
//
//  Created by Jonathan Pappas on 8/24/23.
//

import SpriteKit

public class Padding: Node {
    var __padding__: SKSpriteNode!
    override var type: NodeTypes { .Padding }
    
    private var topPaddingPoints: Double?
    private var topPaddingPercentage: Double?
    private var bottomPaddingPoints: Double?
    private var bottomPaddingPercentage: Double?
    private var leftPaddingPoints: Double?
    private var leftPaddingPercentage: Double?
    private var rightPaddingPoints: Double?
    private var rightPaddingPercentage: Double?
    
    @discardableResult
    public init(_ padding: Double,_ execute: (() -> ())? = nil) {
        super.init(execute)
        
        let size = __node__.calculateAccumulatedFrame()
        //print(size)
        __padding__ = SKSpriteNode.init(color: .white, size: CGSize.init(width: size.size.width + padding, height: size.size.height + padding))
        __padding__.alpha = 0//.1
        __padding__.position = CGPoint.init(x: size.midX - x, y: size.midY - y)
        __node__.addChild(__padding__)
        
        update()
    }
    
    private func update() {
//        width = width.d
//        height = height.d
//        color = regularColor.d
//        corner = corner.d
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
