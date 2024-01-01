//
//  File.swift
//  
//
//  Created by Jonathan Pappas on 10/9/23.
//

import SpriteKit

public extension EditNode {
    func run(_ action: Action) {
        node.run(action)
    }
}
public extension Node {
    func run(_ action: Action) {
        __node__.run(action.convertToSKAction(), withKey: action._name)
    }
}
public extension Scene {
    func run(_ action: Action) {
        trueScene.curr.root.run(action)
    }
}

public extension EditNode {
    func killAction(_ named: String) {
        node.__node__.removeAction(forKey: named)
    }
}
public extension Node {
    func killAction(_ named: String) {
        __node__.removeAction(forKey: named)
    }
}
public extension Scene {
    func killAction(_ named: String) {
        trueScene.curr.root.__node__.removeAction(forKey: named)
    }
}


public enum ActionPickers { // Codable, Equatable, Hashable
    case moveTo(x: Double?, y: Double?)
    case moveBy(x: Double?, y: Double?)
    case rotateTo(a: Double)
    case rotateBy(a: Double)
    case wait
    case sequence([Action])
    case group([Action])
    case fadeTo(alpha: Double)
//        case circle(radius: Double)
//        case elipse(hRadius: Double, vRadius: Double)
    case skater(hRadius: Double, hTimes: Int, vRadius: Double, vTimes: Int)
    case resizeTo(width: Double, height: Double)
    case resizeBy(width: Double, height: Double)
    case scaleTo(x: Double, y: Double)
    case scaleBy(dx: Double, dy: Double)
    case none
    case code(() -> ())
}
public enum ActionTimer: String, Codable, Equatable {
    case linear
    case ease
    case easeIn
    case easeOut
    case circle
    case circleIn
    case circleOut
    case elastic
    case elasticIn
    case elasticOut
    case bounce
}

public class Action { // Codable, Equatable, Hashable
    
//    static public func == (lhs: Action, rhs: Action) -> Bool {
//        return lhs.hashValue == rhs.hashValue
//    }
//
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(self._duration)
//        hasher.combine(self._name)
//        hasher.combine(self._timing)
//        hasher.combine(self._repeatAction)
//        hasher.combine(self._removeWhenComplete)
//        hasher.combine(self._action)
//    }
    
    var _duration: Double = 1.0
    var _name: String = ""
    var _timing: ActionTimer = .linear
    var _repeatAction: Int = 1
    var _removeWhenComplete: Bool = false
    var _action: ActionPickers
    var _whenComplete: [() -> ()] = []
    
    public init(_ a: ActionPickers) {
        self._action = a
    }
    
    public static func sequence(_ actions: [Action]) -> Action {
        return .init(ActionPickers.sequence(actions))
    }
    public static func group(_ actions: [Action]) -> Action {
        return .init(ActionPickers.group(actions))
    }
    public static func moveTo(x: Double, y: Double) -> Action {
        return .init(ActionPickers.moveTo(x: x, y: y))
    }
    public static func moveTo(x: Double) -> Action {
        return .init(ActionPickers.moveTo(x: x, y: nil))
    }
    public static func moveTo(y: Double) -> Action {
        return .init(ActionPickers.moveTo(x: nil, y: y))
    }
    public static func moveBy(x: Double, y: Double) -> Action {
        return .init(ActionPickers.moveBy(x: x, y: y))
    }
    public static func moveBy(x: Double) -> Action {
        return .init(ActionPickers.moveBy(x: x, y: 0))
    }
    public static func moveBy(y: Double) -> Action {
        return .init(ActionPickers.moveBy(x: 0, y: y))
    }
    
    public static func rotate(to: Double) -> Action {
        return .init(ActionPickers.rotateTo(a: to))
    }
    public static func rotate(by: Double) -> Action {
        return .init(ActionPickers.rotateBy(a: by))
    }
    public static func wait(seconds: Double) -> Action {
        return .init(ActionPickers.wait).setDuration(seconds)
    }
    public static func circle(radius: Double) -> Action {
        return .init(ActionPickers.skater(hRadius: radius, hTimes: 1, vRadius: radius, vTimes: 1))
    }
    public static func ellipse(wRadius: Double, hRadius: Double) -> Action {
        return .init(ActionPickers.skater(hRadius: wRadius, hTimes: 1, vRadius: hRadius, vTimes: 1))
    }
    
    public static func fade(to: Double) -> Action {
        return .init(ActionPickers.fadeTo(alpha: to))
    }
    public static var fadeIn: Action {
        return .init(ActionPickers.fadeTo(alpha: 1.0))
    }
    public static var fadeOut: Action {
        return .init(ActionPickers.fadeTo(alpha: 0.0))
    }
    
    public static func resize(width: Double, height: Double) -> Action {
        return .init(ActionPickers.resizeTo(width: width, height: height))
    }
    
    public static func scale(to: Double) -> Action {
        return .init(ActionPickers.scaleTo(x: to, y: to))
    }
    
    public static func code(_ run: @escaping () -> ()) -> Action {
        return .init(ActionPickers.code(run))
    }
    
    
    
    public func setName(_ to: String) -> Action {
        _name = to
        return self
    }
    public func setDuration(_ to: Double) -> Action {
        _duration = to
        return self
    }
    public func setTiming(_ to: ActionTimer) -> Action {
        _timing = to
        return self
    }
    public func repeatForever() -> Action {
        _repeatAction = -1
        return self
    }
    public func repeatAction(_ times: Int) -> Action {
        _repeatAction = times
        return self
    }
    public func removeWhenComplete() -> Action {
        _removeWhenComplete = true
        return self
    }
    public func whenComplete(_ run: @escaping () -> ()) -> Action {
        _whenComplete.append(run)
        return self
    }
    
    func convertToSKAction() -> SKAction {
        let timingFunction: SKActionTimingFunction
        switch _timing {
        case .linear: timingFunction = {$0}
        case .ease: timingFunction =  SineEaseInOut(_:)
        case .easeIn: timingFunction = SineEaseIn(_:)
        case .easeOut: timingFunction = SineEaseOut(_:)
        case .circle: timingFunction = CircularEaseInOut(_:)
        case .circleIn: timingFunction = CircularEaseIn(_:)
        case .circleOut: timingFunction = CircularEaseOut(_:)
        case .elastic: timingFunction = ElasticEaseInOut(_:)
        case .elasticIn: timingFunction = ElasticEaseIn(_:)
        case .elasticOut: timingFunction = ElasticEaseOut(_:)
        case .bounce: timingFunction = BounceEaseOut(_:)
        //default: timingFunction = {$0}
        }
        
        func t(_ s: SKAction) {
            s.timingFunction = timingFunction
        }
        
        var a: SKAction
        
        switch _action {
        case .none: a = SKAction()
        case .wait: a = SKAction.wait(forDuration: _duration).then(t)
        case let .code(r): a = SKAction.run(r)
        case let .moveTo(x: x, y: y):
            if let x = x {
                if let y = y {
                    a = SKAction.move(to: CGPoint.init(x: x, y: y), duration: _duration).then(t)
                } else {
                    a = SKAction.moveTo(x: x, duration: _duration).then(t)
                }
            } else if let y = y {
                a = SKAction.moveTo(y: y, duration: _duration).then(t)
            } else {
                a = SKAction()
            }
        case let .moveBy(x: x, y: y):
            let x = x ?? 0
            let y = y ?? 0
            a = SKAction.moveBy(x: x, y: y, duration: _duration).then(t)
        case let .sequence(actionList): a = SKAction.sequence(actionList.map({ $0.convertToSKAction() })).then(t)
        case let .group(actionList): a = SKAction.group(actionList.map({ $0.convertToSKAction() })).then(t)
        case let .fadeTo(alpha: al): a = SKAction.fadeAlpha(to: al, duration: _duration)
        case let .rotateTo(a: an): a = SKAction.rotate(toAngle: an.toRadians(), duration: _duration).then(t)
        case let .rotateBy(a: an): a = SKAction.rotate(byAngle: an.toRadians(), duration: _duration).then(t)
        case let .resizeTo(width: w, height: h): a = SKAction.resize(toWidth: w, height: h, duration: _duration).then(t)
        case let .resizeBy(width: w, height: h): a = SKAction.resize(byWidth: w, height: h, duration: _duration).then(t)
        case let .scaleTo(x: x, y: y): a = SKAction.scaleX(to: x, y: y, duration: _duration).then(t)
        case let .scaleBy(dx: dx, dy: dy): a = SKAction.scaleX(by: dx, y: dy, duration: _duration).then(t)
        case let .skater(hRadius: hR, hTimes: hT, vRadius: vR, vTimes: vT):
            
            let vDiameterSpeed = _duration/(Double(vT)*2)
            let hDiameterSpeed = _duration/(Double(hT)*2)
            
            let V1 = Self.moveBy(y: 2*vR)
                .setDuration(vDiameterSpeed)
                .setTiming(.ease)
            let V2 = Self.moveBy(y: -2*vR)
                .setDuration(vDiameterSpeed)
                .setTiming(.ease)
            
            let V = Self.sequence([V1, V2])
                .repeatAction(vT)
            
            let H1 = Self.moveBy(x: hR)
                .setDuration(hDiameterSpeed/2)
                .setTiming(.easeOut)
            let H2 = Self.moveBy(x: -2*hR)
                .setDuration(hDiameterSpeed)
                .setTiming(.ease)
            let H3 = Self.moveBy(x: hR)
                .setDuration(hDiameterSpeed/2)
                .setTiming(.easeIn)
            
            let H = Self.sequence([H1, H2, H3])
                .repeatAction(hT)
            
            let circ = Self.group([V, H])
            a = circ.convertToSKAction()
            
        }
        
        
        if _repeatAction == 0 {
            a = SKAction()
        } else if _repeatAction == 1 {
            // nothing
        } else if _repeatAction < 0 {
            a = .repeatForever(a)
        } else {
            a = .repeat(a, count: _repeatAction)
        }
        
        if _removeWhenComplete {
            a = SKAction.sequence([ a, .removeFromParent() ])
        }
        
        return SKAction.sequence([a] + _whenComplete.map { SKAction.run($0) })
        //return a
    }
    
}
