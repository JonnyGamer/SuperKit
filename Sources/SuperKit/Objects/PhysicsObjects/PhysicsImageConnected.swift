//
//  PhysicsImage.swift
//  PappasSpriteKitUITesting
//
//  Created by Jonathan Pappas on 8/22/23.
//

import SpriteKit

public class PhysicsImageConnected: Image, Physics {
    
    private(set) public var __physics__: [SKPhysicsBody] = []//!
    override var type: NodeTypes { .PhysicsImageConnected }
    
    @discardableResult
    public override init(_ named: String, _ execute: (() -> ())? = nil) {
        super.init(named)
        createPhysicsBodyForImage()
        update()
        s(execute)
    }
        
    public var obeysGravity: Bool = true { willSet { __physics__.affectedByGravity = newValue } }
    
    public var stationary: Bool = false { willSet { __physics__.isDynamic = !newValue } }
    
    public var pinned: Bool = false { willSet { __physics__.pinned = newValue } }
    
    public var canSpin: Bool = true { willSet { __physics__.allowsRotation = newValue } }
    
    public var friction: Double = 0.0 { willSet { __physics__.friction = newValue } }
    
    public var drag: Double = 0.0 { willSet {
        let damping = keepInRange(0, newValue/100, 100)
        __physics__.drag = damping
    } }
    
    public var bounciness: Double = 0.0 { willSet { __physics__.restitution = keepInRange(0, newValue/100, 100) } }
    
    public override var xVelocity: Double {
        get { __physics__.velocity.dx }
        set { __physics__.velocity.dx = newValue }
    }
    
    public var yVelocity: Double {
        get { __physics__.velocity.dy }
        set { __physics__.velocity.dy = newValue }
    }
    
    public var rotationalVelocity: Double {
        get { __physics__.angularVelocity.toDegrees() }
        set { __physics__.angularVelocity = newValue.toRadians() }
    }
    
    private func update() {
        obeysGravity = obeysGravity.d
        stationary = stationary.d
        pinned = pinned.d
        canSpin = canSpin.d
        friction = friction.d
        drag = drag.d
        bounciness = bounciness.d
        xVelocity = xVelocity.d
        yVelocity = yVelocity.d
        rotationalVelocity = rotationalVelocity.d
        if __node__.physicsBody == nil {
            __node__.physicsBody = __physics__[0]
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case obeysGravity, stationary, pinned, canSpin, friction, drag, bounciness, xVelocity, yVelocity, rotationalVelocity
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        if obeysGravity != true { try container.encode(self.obeysGravity, forKey: .obeysGravity) }
        if stationary != false { try container.encode(self.stationary, forKey: .stationary) }
        if pinned != false { try container.encode(self.pinned, forKey: .pinned) }
        if canSpin != true { try container.encode(self.canSpin, forKey: .canSpin) }
        if friction != 0.0 { try container.encode(self.friction, forKey: .friction) }
        if drag != 0.0 { try container.encode(self.drag, forKey: .drag) }
        if bounciness != 0.0 { try container.encode(self.bounciness, forKey: .bounciness) }
        if xVelocity != 0.0 { try container.encode(self.xVelocity, forKey: .xVelocity) }
        if yVelocity != 0.0 { try container.encode(self.yVelocity, forKey: .yVelocity) }
        if rotationalVelocity != 0.0 { try container.encode(self.rotationalVelocity, forKey: .rotationalVelocity) }
    }
    
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        createPhysicsBodyForImage()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.obeysGravity = try container.decodeIfPresent(Bool.self, forKey: .obeysGravity) ?? true
        self.stationary = try container.decodeIfPresent(Bool.self, forKey: .stationary) ?? false
        self.pinned = try container.decodeIfPresent(Bool.self, forKey: .pinned) ?? false
        self.canSpin = try container.decodeIfPresent(Bool.self, forKey: .canSpin) ?? true
        self.drag = try container.decodeIfPresent(Double.self, forKey: .drag) ?? 0.0
        self.bounciness = try container.decodeIfPresent(Double.self, forKey: .bounciness) ?? 0.0
        self.xVelocity = try container.decodeIfPresent(Double.self, forKey: .xVelocity) ?? 0.0
        self.yVelocity = try container.decodeIfPresent(Double.self, forKey: .yVelocity) ?? 0.0
        self.rotationalVelocity = try container.decodeIfPresent(Double.self, forKey: .rotationalVelocity) ?? 0.0
        update()
    }
    
    func createPhysicsBodyForImage() {
//        let dimensions = trueSize.width * trueSize.height
//        if dimensions > 100000 {
//            print("Too big to automatically make adjustments. Hope that's okay :)")
//            __physics__ = [SKPhysicsBody.init(texture: __sprite__.texture!, size: .ratio(width, height))]
//            return
//        }
        //__physics__ = []// SKPhysicsBody.init(texture: __sprite__.texture!, size: .ratio(width, height))
        __node__.physicsBody = .init()// __physics__[0] //SKPhysicsBody.init(rectangleOf: .ratio(width, height))
        
        let ps = separateParts(from: __sprite__)
        //emptySprite()
        __sprite__.texture = .invisible()
        for i in ps {
            i.remove()
            __node__.addChild(i.__node__)
            let b = SKPhysicsBody.init(texture: i.__sprite__.texture!, size: i.__sprite__.size)
            i.__node__.physicsBody = b
            i.__node__.addJointPin(__node__)
            __physics__.append(b)
            //__physics__.angularVelocity = 100 * .pi
        }
        for x in 0..<ps.count {
            for y in 0..<ps.count {
                if x == y { continue }
                ps[x].__node__.addJoint(ps[y].__node__)
            }
        }
        
    }
    
}
