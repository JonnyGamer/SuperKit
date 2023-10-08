//
//  SKNodeExtensions.swift
//  PappasSpriteKit
//
//  Created by Jonathan Pappas on 8/1/23.
//

import SpriteKit

public extension SKNode {
    func removeFromParentRecursive(_ count: Bool = false) {
        var c = count
        if scene != nil {
            c = true
        }
        totalNodes -= 1
        removeFromParent()
        for i in children {
            i.removeFromParentRecursive(c)
        }
    }
    func totalChildrenRecursive() -> Int {
        return children.count + children.reduce(0) { $0 + $1.totalChildrenRecursive() }
    }
    func isChildOf(_ node: SKNode) -> Bool {
        if let p = parent {
            if p === node {
                return true
            }
            return p.isChildOf(node)
        }
        return false
    }
    func addJoint(_ with: SKNode) {
        // Add the joint to the physics world
        if !isChildOf(trueScene) { print("Node Joint Cancelled: Node isn't a child of the scene"); return }
        if !with.isChildOf(trueScene) { print("Node Joint Cancelled: Node isn't a child of the scene"); return }
        guard let p = physicsBody else { print("Node Joint Cancelled: Node has no physics body"); return }
        guard let p2 = with.physicsBody else { print("Node Joint Cancelled: Node has no physics body"); return }
        let joint = SKPhysicsJointFixed.joint(withBodyA: p, bodyB: p2, anchor: .zero)
        
        // SKConstraint Totally Didn't Work Lol!
        //let dx = (position.x - with.position.x)
        //let dy = (position.y - with.position.y)
        //let distance = sqrt(dx * dx + dy * dy)
        //let constraint = SKConstraint.distance(SKRange(lowerLimit: distance, upperLimit: distance), to: with)
        //if self.constraints == nil { self.constraints = [] }
        //self.constraints?.append(constraint)
        
        trueScene.physicsWorld.add(joint)
    }
    func addJointPin(_ with: SKNode) {
        // Add the joint to the physics world
        if !isChildOf(trueScene) { print("Node Joint Cancelled: Node isn't a child of the scene"); return }
        if !with.isChildOf(trueScene) { print("Node Joint Cancelled: Node isn't a child of the scene"); return }
        guard let p = physicsBody else { print("Node Joint Cancelled: Node has no physics body"); return }
        guard let p2 = with.physicsBody else { print("Node Joint Cancelled: Node has no physics body"); return }
        let joint = SKPhysicsJointPin.joint(withBodyA: p, bodyB: p2, anchor: with.position)
        
        trueScene.physicsWorld.add(joint)
    }
    var stamp: SKSpriteNode {
        let foo = SKSpriteNode(texture: SKView().texture(from: self))
        foo.texture?.filteringMode = .nearest
        foo.xScale = xScale
        foo.yScale = yScale
        return foo
    }
    func centerAt(_ point: CGPoint) {
        position = point
        let whereThis = calculateAccumulatedFrame()
        position.x += point.x - whereThis.midX
        position.y += point.y - whereThis.midY
    }
    func centerX(_ point: CGFloat) {
        let whereThis = calculateAccumulatedFrame()
        position.x += point - whereThis.midX
    }
    func centerY(_ point: CGFloat) {
        let whereThis = calculateAccumulatedFrame()
        position.y += point - whereThis.midY
    }
    func anchorAt(_ point: CGPoint, anchor: CGPoint) {
        position = point
        let whereThis = calculateAccumulatedFrame()
        position.x += (point.x - whereThis.minX) - whereThis.width * anchor.x
        position.y += (point.y - whereThis.minY) - whereThis.height * anchor.y
    }
    func keepInside(_ this: CGSize) {
        let nodeSize = calculateAccumulatedFrame()
        setScale(min((this.width / nodeSize.width) * xScale, (this.height / nodeSize.height) * yScale))
    }
    func keepInside(width: CGFloat?, height: CGFloat?) {
        guard let width = width else { if let height = height { keepInside(height: height) }; return }
        guard let height = height else { keepInside(width: width); return }
        let nodeSize = calculateAccumulatedFrame()
        setScale(min((width / nodeSize.width) * xScale, (height / nodeSize.height) * yScale))
    }
    func keepInside(width: CGFloat) {
        let nodeSize = calculateAccumulatedFrame()
        setScale((width / nodeSize.width) * xScale)
    }
    func keepInside(height: CGFloat) {
        let nodeSize = calculateAccumulatedFrame()
        setScale((height / nodeSize.height) * yScale)
    }
}

extension Array {
    func first<T>(_ as: T.Type) -> T? {
        return first(where: { $0 is T }) as? T
    }
}

extension SKNode {
    func containsPoint(_ point: CGPoint) -> Bool {
        guard let scene = scene else { return false }
        
        if let a = self as? SKSpriteNode {
            
            // Convert the point from the global coordinate system to the local coordinate system of the node
            let localPoint = convert(point, from: scene)

            // Check if the localPoint is within the unrotated bounding box of the node
            let halfWidth = a.size.width * 0.5
            let halfHeight = a.size.height * 0.5
            let xRange = (-halfWidth)...halfWidth
            let yRange = (-halfHeight)...halfHeight

            guard xRange.contains(localPoint.x) && yRange.contains(localPoint.y) else {
                // The touch point is outside the bounding box, so it's not within the node
                return false
            }
            
            // If spot contains a transparent pixel, also cancel LOL
            if a.containsTransparentPixel(at: localPoint) {
                return false
            }
            
            return true
            
        } else if let a = self as? SKShapeNode {
            let localPoint = convert(point, from: scene)
            return a.path?.contains(localPoint) ?? false
        } else if let a = Everything.find(self) {
            if let a = a as? Button {
                let localPoint = convert(point, from: scene)
                return a.__button__.path?.contains(localPoint) ?? false
            } else if let a = a as? Toggle {
                let localPoint = convert(point, from: scene)
                return a.shape.path?.contains(localPoint) ?? false
            } else if let a = a as? Input {
                let localPoint = convert(point, from: scene)
                return (a.__node__.children[0].children[0] as? SKShapeNode)?.path?.contains(localPoint) ?? false
            }
        }
        
        return true
    }
}

extension SKSpriteNode {
    func getColor(at point: CGPoint) -> Color? {
        guard let texture = self.texture else {
            return nil
        }

        let textureSize = texture.size()
        let x = (point.x + size.width * 0.5) * textureSize.width / size.width
        let y = textureSize.height - ((point.y + size.height * 0.5) * textureSize.height / size.height)

        let image = texture.cgImage()
        
        // Create a data provider from the image
        guard let dataProvider = image.dataProvider else {
            return nil
        }

        // Get the raw pixel data from the image
        guard let pixelData = dataProvider.data else {
            return nil
        }
        
        // Get a pointer to the raw data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)

        // Calculate the position of the pixel in the data buffer
        let pixelInfo: Int = (((image.width * Int(y)) + Int(x)) * 4)
        
        if Int(y) > image.height { return nil }
        if Int(x) > image.width { return nil }
        
        let r = data[pixelInfo]
        let g = data[pixelInfo + 1]
        let b = data[pixelInfo + 2]
        let alpha = data[pixelInfo + 3]
        
        return Color.init(r: r, g: g, b: b, a: alpha)
    }

    func containsTransparentPixel(at point: CGPoint) -> Bool {
        guard let color = getColor(at: point) else {
            // If the node doesn't have a texture, we assume it's not transparent
            return false// true
        }

        // If the color at the touch point is not transparent, it means the pixel is not transparent
        return color.alpha == 0
    }
}

extension SKPhysicsBody {
    
    func transfer(_ to: SKPhysicsBody) {
        to.affectedByGravity = affectedByGravity
        to.allowsRotation = allowsRotation
        to.angularDamping = angularDamping
        to.angularVelocity = angularVelocity
        to.categoryBitMask = categoryBitMask
        to.charge = charge
        to.collisionBitMask = collisionBitMask
        to.contactTestBitMask = contactTestBitMask
        to.density = density
        to.fieldBitMask = fieldBitMask
        to.friction = friction
        to.isDynamic = isDynamic
        to.isResting = isResting
        // to.joints // crap this would break the joints wouldn't it
        to.linearDamping = linearDamping
        to.mass = mass
        to.pinned = pinned
        to.restitution = restitution
        to.usesPreciseCollisionDetection = usesPreciseCollisionDetection
        to.velocity = velocity
    }
    
}


@objc protocol Unpixelate {
    @objc func unpixelate()
}

extension SKLabelNode: Unpixelate {
    func bold() {
        fontName = "SF Pro Rounded"
    }
    func unpixelate() {
        fontSize *= xScale
        setScale(1.0)
    }
    func centerText(_ node: CGSize) {
        keepInside(node)
        centerAt(.zero)
        bold()
        unpixelate()
    }
    func basicText(keepInside: CGSize) {
        //self.bold()
        self.keepInside(keepInside)
        self.unpixelate()
        self.centerAt(.zero)
        //self.fontColor = .black
    }
}

extension SKTexture {
    //    static func clear() -> SKTexture {
    //        let pixelColor = NSColor.clear
    //        let pixelSize = CGSize(width: 1, height: 1)
    //
    //        let pixelImage = NSImage(size: pixelSize)
    //        pixelImage.lockFocus()
    //        pixelColor.drawSwatch(in: NSRect(origin: .zero, size: pixelSize))
    //        pixelImage.unlockFocus()
    //
    //        // Create a texture from the transparent pixel
    //        return SKTexture(image: pixelImage)
    //    }
    static func invisible() -> SKTexture {
        let transparentPixelData: [UInt8] = [0, 0, 0, 0] // RGBA values (black with alpha 0)
                let transparentTexture = SKTexture(data: Data(transparentPixelData),
                                                   size: CGSize(width: 1, height: 1),
                                                   flipped: false)
        return transparentTexture
    }
}
