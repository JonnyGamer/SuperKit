//
//  Overloads.swift
//
//
//  Created by Jonathan Pappas on 8/14/23.
//

import Foundation

// OptionalProtocol is a custom protocol that you'll define
public protocol OptionalProtocol {
    associatedtype Wrapped
    var optional: Wrapped? { get }
}

extension Optional: OptionalProtocol {
    public var optional: Wrapped? { return self }
}

public extension Array where Element: OptionalProtocol {
    func compactMap() -> [Element.Wrapped] {
        return compactMap { $0.optional }
    }
}

// Operator Overloads (Make more generic ones)
public func +=(lhs: inout CGFloat, rhs: Int) {
    lhs += CGFloat(rhs)
}
public func +=(lhs: inout Double, rhs: Int) {
    lhs += Double(rhs)
}
extension Double {
    var tenths: String {
        let woah: Double = (self*10).rounded(.toNearestOrEven)
        if Int(woah) % 10 == 0 {
            return "\(Int(self+0.00001))"
        }
        return "\(Int(self+0.00001)).\((Int(woah) % 10))"
    }
}

prefix operator √
public prefix func √<T: FloatingPoint>(_ some: T) -> T {
    return sqrt(some)
}
public prefix func √(_ some: Int) -> Double {
    return sqrt(Double(some))
}

public extension BinaryFloatingPoint {
    func toDegrees() -> Self {
        return self * 180 / .pi
    }
    func toRadians() -> Self {
        return self * .pi / 180
    }
}

public extension CGPoint {
    func negative() -> Self {
        return .init(x: -x, y: -y)
    }
    static var one: Self {
        return .init(x: 1, y: 1)
    }
    static var half: Self {
        return .init(x: 0.5, y: 0.5)
    }
    static var midPoint: Self {
        return .init(x: width/2, y: height/2)
        //return .init(x: trueScene.size.width/2, y: trueScene.size.height/2)
    }
}
public extension CGSize {
    static var screenSize: Self {
        return trueScene.size
    }
    static var hundred: Self {
        return .init(width: 100, height: 100)
    }
    func times(_ this: CGFloat) -> Self {
        return .init(width: width * this, height: height * this)
    }
    mutating func timesMutate(_ this: CGFloat) {
        self = .init(width: width * this, height: height * this)
    }
    func widen(_ this: CGFloat) -> Self {
        return .init(width: width * this, height: height)
    }
    func heighten(_ this: CGFloat) -> Self {
        return .init(width: width, height: height * this)
    }
    static func ratio(_ w: Double,_ h: Double) -> Self {
        return .init(width: w, height: h)
    }
    func keepInside(_ this: CGSize) -> Self {
        let minScaling = min(this.width / width, this.height / height)
        var newSize = self
        newSize.width *= minScaling
        newSize.height *= minScaling
        return newSize
    }
}

public func sin(_ d: Double) -> Double {
    return Foundation.sin(d)
}
public func cos(_ d: Double) -> Double {
    return Foundation.cos(d)
}
public func cot(_ d: Double) -> Double {
    return 1/Foundation.tan(d)
}
public func tan(_ d: Double) -> Double {
    return Foundation.tan(d)
}
public extension Hashable {
    var dup: Self {
        return self
    }
}

public extension Dictionary where Value: RangeReplaceableCollection {
    mutating func add(_ key: Key, with: Value) {
        if self[key] == nil {
            self[key] = Value.init()
        }
        self[key]! += with
    }
}

public func keepInRange<T: Comparable>(_ min: T,_ value: T,_ max: T) -> T {
    Swift.min(max, Swift.max(min, value))
}

//infix operator ++ : AdditionPrecedence
//extension Dictionary where Key == String {
//    public static func +(_ lhs: [String:Value],_ rhs: [String:Value]) -> [String:Value] where Value: JSON {
//        var foo = lhs
//        for i in rhs {
//            if foo[i.key] != nil { print("Warning: Dictionary composition has duplicate keys, overwriting...") }
//            foo[i.key] = i.value
//        }
//        return foo
//    }
//}
//extension Dictionary {
//    public init(_ this: Self) {
//        self = this
//    }
//}

import CoreGraphics

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}
