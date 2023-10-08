//
//  ObjectProtocols.swift
//  PappasSpriteKitUITesting
//
//  Created by Jonathan Pappas on 8/18/23.
//

import SpriteKit

@objc protocol Colorable {
    var _color: _Color { get set }
}


@objc public protocol Size {
    var width: Double { get set }
    var height: Double { get set }
}

@objc public protocol Physics {
    var obeysGravity: Bool { get set }
    var stationary: Bool { get set }
    var pinned: Bool { get set }
    var canSpin: Bool { get set }
    var friction: Double { get set }
    var drag: Double { get set }
    var bounciness: Double { get set }
    var xVelocity: Double { get set }
    var yVelocity: Double { get set }
    var rotationalVelocity: Double { get set }
    var __node__: SKNode { get }
    //public func joint<SomePhysicsNode: PhysicsNode>(_ with: SomePhysicsNode) { _joint(with) }
}

extension Array where Element: SKPhysicsBody {
    var affectedByGravity: Bool {
        get { self.first?.affectedByGravity ?? false }
        set { self.forEach({ $0.affectedByGravity = newValue }) }
    }
    var isDynamic: Bool {
        get { self.first?.isDynamic ?? false }
        set { self.forEach({ $0.isDynamic = newValue }) }
    }
    var pinned: Bool {
        get { self.first?.pinned ?? false }
        set { self.forEach({ $0.pinned = newValue }) }
    }
    var allowsRotation: Bool {
        get { self.first?.allowsRotation ?? false }
        set { self.forEach({ $0.allowsRotation = newValue }) }
    }
    var friction: CGFloat {
        get { self.first?.friction ?? 0.0 }
        set { self.forEach({ $0.friction = newValue }) }
    }
    var drag: CGFloat {
        get { self.first?.friction ?? 0.0 }
        set { self.forEach({ $0.linearDamping = newValue; $0.angularDamping = newValue }) }
    }
    var restitution: CGFloat {
        get { self.first?.restitution ?? 0.0 }
        set { self.forEach({ $0.restitution = newValue }) }
    }
    var velocity: CGVector {
        get { self.first?.velocity ?? .zero }
        set { self.forEach({ $0.velocity = newValue }) }
    }
    var angularVelocity: CGFloat {
        get { self.first?.angularVelocity ?? 0.0 }
        set {
            self.forEach({ $0.angularVelocity = newValue })
        }
    }
}


public protocol NodeView {
    var body: Node { get }
    var node: Node! { get set }
}
extension NodeView {
    @discardableResult
    public func callAsFunction(_ edit: @escaping () -> ()) -> Node {
        s(edit)
        return node
    }
    
    @discardableResult
    func s(_ e: (() -> ())?) -> Node {
        if let e = e {
            stack.append(node)
            e()
            if !stack.isEmpty {
                stack.removeLast()
            }
        }
        return node
    }
}


@objc protocol Inputable {
    var _lineLocation: Int { get set }
    var _characterLocation: Int { get set }
    var _selected: Bool { get set }
    var text : Text2D { get }
    func render()
}

extension Inputable {
    var selected: Bool {
        get { _selected  }
        set { if _selected != newValue { _selected = newValue; render() } }
    }
    func select() {
        selected = true
    }
    func deselect() {
        selected = false
    }
    var cursorLocation: (line: Int, character: Int) {
        get { (_lineLocation, _characterLocation) }
        set { _lineLocation = newValue.line; _characterLocation = newValue.character }
    }
    
    var description: String {
        typeLetter("|")
        let tD = text.description
        delete()
        return "--------------------\n" + tD
    }
    func typeLetter(_ n: String) {
        text.insert(n, at: cursorLocation)
        _characterLocation += 1
    }
    func enter() {
        text.insertCarriageReturn(at: cursorLocation)
        _lineLocation += 1
        _characterLocation = 0
    }
    func delete() {
        if cursorLocation == (0,0) { return }
        if cursorLocation.character == 0 {
            cursorLocation = text.deleteCarriageReturn(at: cursorLocation)
        } else {
            text.delete(at: cursorLocation)
            cursorLocation.character -= 1
        }
    }
    func commandDelete() {
        while cursorLocation.character > 0 {
            delete()
        }
    }
    func optionDelete() {
        if cursorLocation == (0,0) { return }
        if cursorLocation.character == 0 {
            delete()
        }
        var foundAlphaNumeric = false
        while cursorLocation.character > 0 {
            let char = text.character(at: cursorLocation)
            if char.isLetter || char.isNumber {
                foundAlphaNumeric = true
            }
            if foundAlphaNumeric, !char.isLetter, !char.isNumber {
                break
            }
            delete()
        }
    }
    
    
    func commandLeft() {
        cursorLocation.character = 0
    }
    func optionLeft() {
        if cursorLocation == (0,0) { return }
        if cursorLocation.character == 0 {
            left()
        }
        var foundAlphaNumeric = false
        while cursorLocation.character > 0 {
            let char = text.character(at: cursorLocation)
            if char.isLetter || char.isNumber {
                foundAlphaNumeric = true
            }
            if foundAlphaNumeric, !char.isLetter, !char.isNumber {
                break
            }
            left()
        }
    }
    func left() {
        if cursorLocation == (0,0) { return }
        if cursorLocation.character == 0 {
            cursorLocation.line -= 1
            cursorLocation.character = text.numberOfCharacters(at: cursorLocation)
        } else {
            cursorLocation.character -= 1
        }
    }
    
    func commandRight() {
        cursorLocation.character = text.numberOfCharacters(at: cursorLocation)
    }
    func optionRight() {
        if cursorLocation == text.endOfText() { return }
        if cursorLocation.character == text.numberOfCharacters(at: cursorLocation) {
            right()
        }
        var foundAlphaNumeric = false
        let endOfLine = text.numberOfCharacters(at: cursorLocation)
        while cursorLocation.character < endOfLine {
            let char = text.character(at: (cursorLocation.line, cursorLocation.character+1))
            if char.isLetter || char.isNumber {
                foundAlphaNumeric = true
            }
            if foundAlphaNumeric, !char.isLetter, !char.isNumber {
                break
            }
            right()
        }
    }
    func right() {
        if cursorLocation == text.endOfText() { return }
        if cursorLocation.character == text.numberOfCharacters(at: cursorLocation) {
            cursorLocation.line += 1
            cursorLocation.character = 0
        } else {
            cursorLocation.character += 1
        }
    }
    func down() {
        if cursorLocation.line == text.endOfText().line { return }
        cursorLocation.line += 1
        cursorLocation.character = min(text.numberOfCharacters(at: cursorLocation), cursorLocation.character)
    }
    func up() {
        if cursorLocation.line == 0 { return }
        cursorLocation.line -= 1
        cursorLocation.character = min(text.numberOfCharacters(at: cursorLocation), cursorLocation.character)
    }
    func commandDown() {
        cursorLocation = text.endOfText()
    }
    func commandUp() {
        cursorLocation = (0,0)
    }
}
