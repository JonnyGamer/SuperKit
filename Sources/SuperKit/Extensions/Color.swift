//
//  Sprite.swift
//  PappasSpriteKit
//
//  Created by Jonathan Pappas on 5/5/23.
//

import SpriteKit

extension String {
    var color: (r:UInt8,g:UInt8,b:UInt8) {
        let scanner = Scanner(string: self)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        return (UInt8(r), UInt8(g), UInt8(b))
    }
}

extension NSColor {
    convenience init(hex: String) {
        let (r,g,b) = hex.color
        self.init(r: r, g: g, b: b)
    }
    convenience init(r: UInt8, g: UInt8, b: UInt8, a: UInt8 = .max) {
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff,
            alpha: CGFloat(a) / 0xff
        )
    }
    func color() -> Color {
        Color.init(r: UInt8(self.redComponent * 0xff), g: UInt8(self.greenComponent * 0xff), b: UInt8(self.blueComponent * 0xff), a: UInt8(self.alphaComponent * 0xff))
    }
}

#if os(iOS)
typealias NSColor = UIColor
#endif

@objc public class _Color: NSObject {
    var r: UInt8
    var g: UInt8
    var b: UInt8
    var a: UInt8
    init(r: UInt8, g: UInt8, b: UInt8, a: UInt8) {
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }
    func c() -> Color { return .init(r: r, g: g, b: b, a: a) }
    func s(_ c: Color) { (r, g, b, a) = (c.r, c.g, c.b, c.a) }
}

public struct Color: Codable, Equatable, Hashable {
    func c() -> _Color { return .init(r: r, g: g, b: b, a: a) }
    var r: UInt8
    var g: UInt8
    var b: UInt8
    var a: UInt8
    var rgb: (CGFloat, CGFloat, CGFloat) { (CGFloat(r)/255, CGFloat(g)/255, CGFloat(b)/255) }
    public var red: UInt8 { get { r } set { r = newValue} }
    public var green: UInt8 { get { g } set { g = newValue} }
    public var blue: UInt8 { get { b } set { b = newValue} }
    public var alpha: UInt8 { get { a } set { a = newValue} }
    
    var nsColor: NSColor { return .init(r: red, g: green, b: blue, a: alpha) }
    
    public init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        (self.r, self.g, self.b, self.a) = (UInt8(r*255), UInt8(g*255), UInt8(b*255), UInt8(a*255))
    }
    public init(r: UInt8, g: UInt8, b: UInt8) {
        (self.r, self.g, self.b, self.a) = (r, g, b, .max)
    }
    public init(r: UInt8, g: UInt8, b: UInt8, a: UInt8) {
        (self.r, self.g, self.b, self.a) = (r, g, b, a)
    }
    public init(hex: String) {
        (r, g, b) = hex.color
        a = .max
    }
    
    public static var black: Self { Color.init(hex: "000000") }
    public static var blue: Self { Color.init(hex: "c0d8da") }
    public static var darkBlue: Self { Color.init(hex: "8aabb0") }
    public static var lightGray: Self { Color.init(hex: "cecece") }
    public static var darkGray: Self { Color.init(hex: "848484") }
    public static var orange: Self { Color.init(hex: "e9c1a7") }
    public static var green: Self { Color.init(hex: "9bb085") }
    public static var darkYellow: Self { Color.init(hex: "b89c5d") }
    public static var purple: Self { Color.init(hex: "885ca7") }
    public static var white: Self { Color.init(hex: "ffffff") }
    public static var redSelection: Self { Color.init(hex: "ff8888") }
    public static var clear: Self { Color.init(r: UInt8.zero, g: 0, b: 0, a: 0) }
}

//
//
//
//
//extension SKAction {
//    static func fillColor<T: SKNode>(from: (r: CGFloat, g: CGFloat, b: CGFloat), to: (r: CGFloat, g: CGFloat, b: CGFloat), duration: Double, colorize: [ReferenceWritableKeyPath<T, NSColor>] = []) -> SKAction {
//        return .customAction(withDuration: duration, actionBlock: { i, j in
//            let rinseR = from.r + (to.r - from.r) * j / CGFloat(duration)
//            let rinseG = from.g + (to.g - from.g) * j / CGFloat(duration)
//            let rinseB = from.b + (to.b - from.b) * j / CGFloat(duration)
//            for c in colorize {
//                (i as? T)?[keyPath: c] = NSColor.init(red: rinseR, green: rinseG, blue: rinseB, alpha: 1.0)
//            }
//        })
//    }
//}
//
//extension SKAction {
//    static func fillColor<T: SKNode>(from: Color, to: Color, duration: Double, colorize: ReferenceWritableKeyPath<T, NSColor>...) -> SKAction {
//        .fillColor(from: from.rgb, to: to.rgb, duration: duration, colorize: colorize)
//    }
//}
//
//extension SKShapeNode {
//    func setColor(_ to: UIColor) {
//        fillColor = to//.hexColor
//        strokeColor = to//.hexColor
//    }
//}

public extension SKAction {
    static func color<T: AnyObject>(_ node: T, from: (r: CGFloat, g: CGFloat, b: CGFloat), to: (r: CGFloat, g: CGFloat, b: CGFloat), duration: Double, colorize: [ReferenceWritableKeyPath<T, Color>] = []) -> SKAction {
        return .customAction(withDuration: duration, actionBlock: { i, j in
            let rinseR = from.r + (to.r - from.r) * j / CGFloat(duration)
            let rinseG = from.g + (to.g - from.g) * j / CGFloat(duration)
            let rinseB = from.b + (to.b - from.b) * j / CGFloat(duration)
            for c in colorize {
                node[keyPath: c] = Color.init(r: rinseR, g: rinseG, b: rinseB, a: 1.0)
                //(i as? T)?[keyPath: c]
            }
        })
    }
    static func color<T: AnyObject>(_ node: T, from: (r: CGFloat, g: CGFloat, b: CGFloat), to: (r: CGFloat, g: CGFloat, b: CGFloat), duration: Double, colorize: [ReferenceWritableKeyPath<T, NSColor>] = []) -> SKAction {
        return .customAction(withDuration: duration, actionBlock: { i, j in
            let rinseR = from.r + (to.r - from.r) * j / CGFloat(duration)
            let rinseG = from.g + (to.g - from.g) * j / CGFloat(duration)
            let rinseB = from.b + (to.b - from.b) * j / CGFloat(duration)
            for c in colorize {
                node[keyPath: c] = NSColor.init(red: rinseR, green: rinseG, blue: rinseB, alpha: 1.0)
                //(i as? T)?[keyPath: c]
            }
        })
    }
}

public extension SKAction {
    static func color<T: AnyObject>(_ node: T, from: Color, to: Color, duration: Double, colorize: ReferenceWritableKeyPath<T, Color>...) -> SKAction {
        .color(node, from: from.rgb, to: to.rgb, duration: duration, colorize: colorize)
    }
    static func color<T: AnyObject>(_ node: T, from: Color, to: Color, duration: Double, colorize: ReferenceWritableKeyPath<T, NSColor>...) -> SKAction {
        .color(node, from: from.rgb, to: to.rgb, duration: duration, colorize: colorize)
    }
    static func color<T: AnyObject>(_ node: T, from: (r: CGFloat, g: CGFloat, b: CGFloat), to: (r: CGFloat, g: CGFloat, b: CGFloat), duration: Double, colorize: ReferenceWritableKeyPath<T, Color>...) -> SKAction {
        .color(node, from: from, to: to, duration: duration, colorize: colorize)
    }
    static func color<T: AnyObject>(_ node: T, from: (r: CGFloat, g: CGFloat, b: CGFloat), to: (r: CGFloat, g: CGFloat, b: CGFloat), duration: Double, colorize: ReferenceWritableKeyPath<T, NSColor>...) -> SKAction {
        .color(node, from: from, to: to, duration: duration, colorize: colorize)
    }
}
