//
//  File.swift
//  
//
//  Created by Jonathan Pappas on 2/26/24.
//

import Foundation
public class Board: Node, Size {
    
    public let rows: Int
    public let columns: Int
    private var boxen : [Box] = []
    public var width: Double
    public var height: Double
    
    private var _tileScale: Double = 1.0
    public var tileScale: Double {
        get { _tileScale }
        set {
            _tileScale = newValue
            for i in boxen {
                i.node.scale = newValue
            }
        }
    }
    
    @discardableResult
    public init(width: Int, height: Int, maxWidth: Double = 1600, maxHeight: Double = 1000, execute: (() -> ())? = nil) {
        self.rows = height
        self.columns = width
        let blockSize = Double( min( maxHeight / Double(rows), maxWidth / Double(columns) ))
        self.width = blockSize * Double(width)
        self.height = blockSize * Double(height)
        super.init()
        
        //let (widthBound, heightBound) = keepInside
        // let xDiff = 1600 - (blockSize * Double(columns))
        // let yDiff = 1000 - (blockSize * Double(rows))
        
        // let blockSize : Double = 100
        
        self {
            
            for row in 1...self.rows {
                for column in 1...self.columns {
                    
                    Box(width: blockSize, height: blockSize) {
                        this.color = .black
                        this.x = Double(column) * blockSize - (this.width / 2) //+ xDiff/2
                        this.y = Double(row) * blockSize - (this.height / 2) //+ yDiff/2
                        //this.scale = 1.0
                        //this.name = "\(row)-\(column)"
    //                    this.whenTapped {
    //                        self.tapBox(x: row, y: column)
    //                    }
                    }
                    //self.boxen.append(box)
                    
                    let box = Box(width: blockSize, height: blockSize) {
                        this.color = .white
                        this.x = Double(column) * blockSize - (this.width / 2) //+ xDiff/2
                        this.y = Double(row) * blockSize - (this.height / 2) //+ yDiff/2
                        this.scale = 1.0//max(0.0, min(1.0, scale))
                        this.name = "\(row)-\(column)"
    //                    this.whenTapped {
    //                        self.tapBox(x: row, y: column)
    //                    }
                    }
                    self.boxen.append(box)
                }
            }
            
            execute?()
            
        }
    }
    
    public func find(x: Int, y: Int,_ activity: @escaping () -> ()) {
        if x < 0 || x >= columns { return }
        if y < 0 || y >= rows { return }
        boxen[x + y * columns].node {
            activity()
        }
    }
    
    public func id(_ id: Int,_ activity: @escaping () -> ()) {
        if id < 0 || id >= columns * rows { return }
        boxen[id].node {
            activity()
        }
    }
    
    public func allTiles(_ run: @escaping () -> ()) {
        for x in 0..<columns {
            for y in 0..<rows {
                find(x: x, y: y, run)
            }
        }
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    public func switchColor() {
        if this.color == .black {
            this.color = .white
        } else if this.color == .white {
            this.color = .black
        }
    }
    
    public func solve(_ speed: Double = 1.0) -> Action {
        
        var actions: [Action] = []
        
        var o : [Bool] = []
        allTiles {
            o.append(this.color == .black)
        }
        
        for (id, swit) in o.enumerated() {
            if swit {
                actions.append(.sequence([.wait(seconds: speed), .code {
                    self.id(id) {
                        //self.switchColor()
                        
                        let x = id % self.columns
                        let y = id / self.columns
                        
                        for i in 0..<self.columns {
                            self.find(x: i, y: y) {
                                self.switchColor()
                            }
                        }
                        for i in 0..<self.rows {
                            self.find(x: x, y: i) {
                                self.switchColor()
                            }
                        }
                        self.switchColor()
                        
                        
                    }
                }]))
            }
        }
        
        return .sequence([.wait(seconds: 1.0), .sequence(actions)])
        
    }
}


public extension Array where Element: Hashable {
    mutating func removeAll(_ these: Element) {
        self.removeAll { i in
            i == these
        }
    }
    static func -(lhs: Self, rhs: Self) -> Self {
        var new = lhs
        for i in rhs {
            if new.contains(i) {
                new.removeAll(i)
            }
        }
        return new
    }
    static func -=(lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
}


//public extension Direction {
//    func opposite() -> Self {
//        switch self {
//        case .up: return .down
//        case .down: return .up
//        case .left: return .right
//        case .right: return .left
//        case .none: return .none
//        }
//    }
//}

public extension Board {
    func paint(x: Int, y: Int, color: Color) {
        find(x: x, y: y) {
            this.color = color
        }
    }
    func paint(_ pos: Pos,_ color: Color) {
        find(x: pos.x, y: pos.y) {
            this.color = color
        }
    }
    func positions() -> [Pos] {
        var l: [Pos] = []
        for x in 0..<self.columns {
            for y in 0..<self.columns {
                l.append(Pos(x, y))
            }
        }
        return l
    }
}

public struct Pos: Hashable {
    public var x: Int, y: Int
    public init(_ x: Int,_ y: Int) {
        self.x = x; self.y = y
    }
    public static var zero: Self { Pos(0,0) }
}
