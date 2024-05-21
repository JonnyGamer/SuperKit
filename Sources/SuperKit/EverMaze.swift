//
//  File.swift
//  
//
//  Created by Jonathan Pappas on 5/20/24.
//


public extension BinaryInteger {
    func get<T: BinaryInteger>(x: T, y: T) -> Bool {
        _get(at: y * 8 + x)
    }
    func _get<T: BinaryInteger>(at: T) -> Bool {
        (self >> at) % 2 == 1
    }
    mutating func paint<T: BinaryInteger>(x: T, y: T) {
        _paint(at: y * 8 + x)
    }
    func painted<T: BinaryInteger>(x: T, y: T) -> Self {
        _painted(at: y * 8 + x)
    }
    mutating func _paint<T: BinaryInteger>(at: T) {
        self |= 1 << at
    }
    func _painted<T: BinaryInteger>(at: T) -> Self {
        self | 1 << at
    }
    mutating func erase<T: BinaryInteger>(x: T, y: T) {
        _erase(at: y * 8 + x)
    }
    mutating func _erase<T: BinaryInteger>(at: T) {
        if _get(at: at) {
            self -= 1 << at
        }
    }
    mutating func erased<T: BinaryInteger>(x: T, y: T) -> Self {
        _erased(at: y * 8 + x)
    }
    func _erased<T: BinaryInteger>(at: T) -> Self {
        if _get(at: at) {
            return self - 1 << at
        }
        return self
    }
}

public struct Grid64 {
    public var grid: UInt64 = 0
    public static var zero: Self { .init() }
    // x: T, y: T, width: T
    public func get<T: BinaryInteger>(at: T) -> Bool {
        grid._get(at: at)
    }
    public mutating func paint<T: BinaryInteger>(at: T) {
        grid._paint(at: at)
    }
    public mutating func erase<T: BinaryInteger>(at: T) {
        grid._erase(at: at)
    }
}

public struct Grid128 {
    public var grid: UInt64 = 0
    public var gridLast: UInt64 = 0
    public static var zero: Self { .init() }
    
    public func spread<T: BinaryInteger>(at: T) -> (T,T) {
        let on = at / 64
        let atm = at % 64
        return (on, atm)
    }
    
    public func get<T: BinaryInteger>(at: T) -> Bool {
        let (on, atm) = spread(at: at)
        switch on {
        case 0: return grid._get(at: atm)
        default: return gridLast._get(at: atm)
        }
    }
    public mutating func paint<T: BinaryInteger>(at: T) {
        let (on, atm) = spread(at: at)
        switch on {
        case 0: return grid._paint(at: atm)
        default: return gridLast._paint(at: atm)
        }
    }
    public mutating func erase<T: BinaryInteger>(at: T) {
        let (on, atm) = spread(at: at)
        switch on {
        case 0: return grid._erase(at: atm)
        default: return gridLast._erase(at: atm)
        }
    }
}


public struct Grid1024 {
    public var grid: UInt64 = 0
    public var grid1: UInt64 = 0
    public var grid2: UInt64 = 0
    public var grid3: UInt64 = 0
    public var grid4: UInt64 = 0
    public var grid5: UInt64 = 0
    public var grid6: UInt64 = 0
    public var grid7: UInt64 = 0
    public var grid8: UInt64 = 0
    public var gridLast: UInt64 = 0
    public static var zero: Self { .init() }
    
    public func spread<T: BinaryInteger>(at: T) -> (T,T) {
        let on = at / 64
        let atm = at % 64
        return (on, atm)
    }
    
    public func get<T: BinaryInteger>(at: T) -> Bool {
        let (on, atm) = spread(at: at)
        switch on {
        case 0: return grid._get(at: atm)
        case 1: return grid1._get(at: atm)
        case 2: return grid2._get(at: atm)
        case 3: return grid3._get(at: atm)
        case 4: return grid4._get(at: atm)
        case 5: return grid5._get(at: atm)
        case 6: return grid6._get(at: atm)
        case 7: return grid7._get(at: atm)
        case 8: return grid8._get(at: atm)
        default: return gridLast._get(at: atm)
        }
    }
    public mutating func paint<T: BinaryInteger>(at: T) {
        let (on, atm) = spread(at: at)
        switch on {
        case 0: return grid._paint(at: atm)
        case 1: return grid1._paint(at: atm)
        case 2: return grid2._paint(at: atm)
        case 3: return grid3._paint(at: atm)
        case 4: return grid4._paint(at: atm)
        case 5: return grid5._paint(at: atm)
        case 6: return grid6._paint(at: atm)
        case 7: return grid7._paint(at: atm)
        case 8: return grid8._paint(at: atm)
        default: return gridLast._paint(at: atm)
        }
    }
    public mutating func erase<T: BinaryInteger>(at: T) {
        let (on, atm) = spread(at: at)
        switch on {
        case 0: return grid._erase(at: atm)
        case 1: return grid1._erase(at: atm)
        case 2: return grid2._erase(at: atm)
        case 3: return grid3._erase(at: atm)
        case 4: return grid4._erase(at: atm)
        case 5: return grid5._erase(at: atm)
        case 6: return grid6._erase(at: atm)
        case 7: return grid7._erase(at: atm)
        case 8: return grid8._erase(at: atm)
        default: return gridLast._erase(at: atm)
        }
    }
}

public struct Pos2DFourPairs: Hashable, CustomStringConvertible {
    public typealias Mega = Int8
    private var _x1: Mega
    private var _x2: Mega
    private var _x3: Mega
    private var _x4: Mega
    
    private var _y1: Mega
    private var _y2: Mega
    private var _y3: Mega
    private var _y4: Mega
    
    public var x1: Int {
        get { Int(_x1) }
        set { _x1 = Mega(newValue) }
    }
    public var x2: Int {
        get { Int(_x2) }
        set { _x2 = Mega(newValue) }
    }
    public var x3: Int {
        get { Int(_x3) }
        set { _x3 = Mega(newValue) }
    }
    public var x4: Int {
        get { Int(_x4) }
        set { _x4 = Mega(newValue) }
    }
    
    public var y1: Int {
        get { Int(_y1) }
        set { _y1 = Mega(newValue) }
    }
    public var y2: Int {
        get { Int(_y2) }
        set { _y2 = Mega(newValue) }
    }
    public var y3: Int {
        get { Int(_y3) }
        set { _y3 = Mega(newValue) }
    }
    public var y4: Int {
        get { Int(_y4) }
        set { _y4 = Mega(newValue) }
    }
    
    public var description: String { "hello" }
    public static var orthagonal: [EverPos] = [EverPos(1, 0), EverPos(-1, 0), EverPos(0, 1), EverPos(0, -1)]
}


// Can be updated for Point1D or Point3D etc.
public struct EverPos: Hashable, CustomStringConvertible {
    private var _x: Int32 = 0
    private var _y: Int32 = 0
    public var x: Int {
        get { Int(_x) }
        set { _x = Int32(newValue) }
    }
    public var y: Int {
        get { Int(_y) }
        set { _y = Int32(newValue) }
    }
    public static var zero: Self { .init() }
    public var dot: Int { x * y }
    public init() {}
    public init(x: Int32, y: Int32) {
        (self._x, self._y) = (x, y)
    }
    public init(_ x: Int,_ y: Int) {
        (self._x, self._y) = (Int32(x), Int32(y))
    }
    public var description: String { "(x: \(x), y: \(y))" }
    public static func +(lhs: Self, rhs: Self) -> Self {
        return EverPos(x: lhs._x + rhs._x, y: lhs._y + rhs._y)
    }
    public static func +=(lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    
    static var orthagonal: [EverPos] = [EverPos(1, 0), EverPos(-1, 0), EverPos(0, 1), EverPos(0, -1)]
}

import Algorithms

public struct EverMaze {

    public var grid: Grid1024 = .zero
    public static var zero: Self { .init() }
    
    public func get<T: BinaryInteger>(at: T) -> Bool {
        grid.get(at: at)
    }
    public mutating func paint<T: BinaryInteger>(at: T) {
        grid.paint(at: at)
    }
    public mutating func erase<T: BinaryInteger>(at: T) {
        grid.erase(at: at)
    }
}

public struct MetaEverMaze {
    public var size: EverPos
    public var width: Int { size.x }
    public var height: Int { size.y }
    public var current: EverMaze = .zero
    
    // Calculate all EverPossible movements for 1 player
    // var movements: [EverPos: Set<EverPos>] = [:]
    
    
    public init(width: Int, height: Int) {
        size = EverPos(width, height)
    }
    
    public func at(x: Int, y: Int) -> Int { y * width + x }
    public func loc(at: Int) -> EverPos { EverPos(at % width, at / width) }
    public func get(x: Int, y: Int) -> Bool { current.get(at: at(x: x, y: y)) }
    public func get(_ EverPos: EverPos) -> Bool { current.get(at: at(x: EverPos.x, y: EverPos.y)) }
    public func get(at: Int) -> Bool { current.get(at: at) }
    
    public mutating func paint(x: Int, y: Int) {
        current.paint(at: at(x: x, y: y))
        _all_open_tiles?.remove(EverPos(x, y))
    }
    public mutating func erase(x: Int, y: Int) {
        current.erase(at: at(x: x, y: y))
        _all_open_tiles?.insert(EverPos(x, y))
    }
    public mutating func clear() { current = .zero; _all_open_tiles = nil }
    
    public mutating func randomize(probability: Double) {
        clear()
        for i in 0..<width*height {
            let r = Double.random(in: 0..<1)
            if r < probability {
                current.paint(at: i)
            }
        }
    }
    public func inside(_ EverPos: EverPos) -> Bool {
        if EverPos.x < 0 { return false }
        if EverPos.y < 0 { return false }
        if EverPos.x >= width { return false }
        if EverPos.y >= height { return false }
        return true
    }
    public func test_move(EverPos: EverPos, d: EverPos) -> EverPos {
        var EverPos = EverPos
        while true {
            let tryEverPos = EverPos + d
            if !inside(tryEverPos) { return EverPos }
            if get(tryEverPos) { return EverPos }
            EverPos = tryEverPos
        }
    }
    public func test_move_multiple(EverPos: [EverPos], d: EverPos) -> [EverPos] {
        if EverPos.isEmpty { return [] }
        var newEverPos = EverPos
        let balls = EverPos.count
        var haventBumpedWall: Set<Int> = Set(0..<balls)
        while !haventBumpedWall.isEmpty {
            for i in 0..<balls {
                if !haventBumpedWall.contains(i) { continue }
                
                var ball = newEverPos[i]
                
                while true {
                    let tryEverPos = ball + d
                    if newEverPos.contains(tryEverPos), let index = newEverPos.firstIndex(of: tryEverPos) {
                        if !haventBumpedWall.contains(index) { haventBumpedWall.remove(i) }
                        break
                    }
                    if !inside(tryEverPos) { haventBumpedWall.remove(i); break }
                    if get(tryEverPos) { haventBumpedWall.remove(i); break }
                    ball = tryEverPos
                }
                
                newEverPos[i] = ball
            }
        }
        return newEverPos
    }
    
    // Calculate all Open Tiles
    private var _all_open_tiles: Set<EverPos>? = nil
    public mutating func all_open_tiles() -> Set<EverPos> {
        if let a = _all_open_tiles { return a }
        var s: Set<EverPos> = []
        for i in 0..<size.dot {
            if !get(at: i) {
                s.insert(loc(at: i))
            }
        }
        _all_open_tiles = s
        return s
    }
    
    public mutating func connect_grid() -> [EverPos : Set<EverPos>] {
        var movements: [EverPos: Set<EverPos>] = [:]
        
        for tile in all_open_tiles() {
            movements[tile] = []
            for d in EverPos.orthagonal {
                let new = test_move(EverPos: tile, d: d)
                if new == tile { continue }
                movements[tile]?.insert(new)
            }
            if movements[tile]?.isEmpty == true {
                movements[tile] = nil
            }
        }
        
        return movements
    }
    
    public mutating func connect_grid(players: Int) -> [Set<EverPos> : Set<Set<EverPos>>] {
        var movements: [Set<EverPos>: Set<Set<EverPos>>] = [:]
        
        //print("working...")
        for i in all_open_tiles().combinations(ofCount: players) {
            let seti = Set(i)
            //print(seti)
            movements[seti] = []
            for d in EverPos.orthagonal {
                let new = test_move_multiple(EverPos: i, d: d)
                if new == i { continue }
                let setnew = Set(new)
                movements[seti]?.insert(setnew)
            }
            if movements[seti]?.isEmpty == true {
                movements[seti] = nil
            }
        }
        //print("done")
        return movements
    }
    
    // description lol
    public func output() -> String {
        var o = " "
        o += String.init(repeating: "_", count: Int(width)*2)
        o += "\n"
        var on = 0
        for y in (0..<height).reversed() {
            o += "|"
            for x in 0..<width {
                if current.get(at: at(x: x, y: y)) {
                    o += "[]"
                } else {
                    o += "  "
                }
                on += 1
            }
            o += "|\n"
        }
        o += " "
        o += String.init(repeating: "‾", count: Int(width)*2)
        return o
    }
    
    public func code() -> String {
        return "\(current.grid.grid)"
    }
    
}

public func greatest_distance<T: Equatable, U: Sequence>(_ o: [T: U]) -> (Int , [T: Set<T>]) where U.Element == T {
    var largest = 0
    var largestKey: [T: Set<T>] = [:]
    
    for (key, val) in o {
        // find height of key
        var tree: [T: Int] = [key: 0]
        for i in val {
            tree[i] = 1
        }
        var found: [T] = Array(val)
        while !found.isEmpty {
            let item = found.removeFirst()
            guard let newVals = o[item] else { continue }
            let prevDist = tree[item]!
            for i in newVals {
                if tree[i] != nil { continue }
                tree[i] = prevDist + 1
                found.append(i)
            }
        }
        
        //print("WJHA", tree.sorted(by: { $0.value > $1.value })[0])
        for i in tree {
            if i.value > largest {
                largest = i.value
                //print("NEW RECORD", largest)
                largestKey = [:]
            }
            if i.value == largest {
                largestKey[key] = []
                largestKey[key]?.insert(i.key)
            }
        }
        
    }
    return (largest, largestKey)
    //print("-", largest)
    //print(largestKey.count)
}



open class EverMazeScene: Scene {

    public init() { }
    
    public var grid = Infinite2DGrid()
    public var everMaze = MetaEverMaze(width: 8, height: 8)
    public var board = Board(width: 8, height: 8)
    public var players = 2
    public var boardColor: Color = .redSelection
    public var winColor: Color = .darkGray
    public var baseNode = Node()
    public var moves = 0
    public var movesLabel = Text("Moves: 0")
    public var difficulty = Text("Goal: 0")
    public var puzzle: UInt64 = 0//41113288903393604// 1838106507154276587 //2315026132614841384 //14202016909085464784 //4794269601118590273
    public var speed = 0.2
    
    open func createPuzzle() {
        
    }
    
    public func began() {
        
        createPuzzle()
        
        board {
            this.centerScreen()
        }
        board.allTiles {
            this.color = self.boardColor
        }
        
        //tap_tile(x: 0, y: 1)
        backgroundColor = .black
        
        movesLabel {
            this.x = 1600 - 100
            this.y = 100
            this.color = .red
        }
        difficulty {
            this.x = 1600 - 100
            this.y = 50
            this.color = .red
        }
        
        var x = 0
        var y = 0
        while puzzle != 0 {
            if puzzle % 2 == 1 {
                tap_tile(x: x, y: y)
            }
            x += 1
            if x == 8 { x = 0; y += 1 }
            puzzle /= 2
        }
    }
    
    public var startingPositions: [EverPos] = []
    public var ballPositions: [EverPos] = []
    public var balls: [Circle] = []
    public var endPositions: Set<EverPos> = []
    public var ends: [Circle] = []
    
    public func remove_players() {
        for ball in balls {
            ball.remove()
        }
        balls.removeAll()
        ballPositions = []
        startingPositions = []
        for end in ends {
            end.remove()
        }
        ends.removeAll()
        endPositions = []
    }
    
    public var different = true
    
    public func solve() {
        print(everMaze.output())
        moves = 0
        movesLabel.text = "Moves: 0"
        
        if !different {
            ballPositions = startingPositions
            for (i, pos) in ballPositions.enumerated() {
                board.find(x: pos.x, y: pos.y) {
                    self.balls[i].moveTo(this.node)
                    self.balls[i].x = 0
                    self.balls[i].y = 0
                    self.balls[i].moveTo(self.baseNode)
                }
            }
            return
        }
        
        different = false
        
        let movements = everMaze.connect_grid(players: players)
        let (r, w) = greatest_distance(movements)
        difficulty.text = "Goal: " + String(r)
        remove_players()
        
        guard let (start, endings) = w.first else { return }
        guard let ending = endings.first else { return }
        
        for pos in start {
            board.find(x: pos.x, y: pos.y) {
                let ball = Circle(radius: 50)
                ball.moveTo(self.baseNode)
                ball.layer = 1
                self.balls.append(ball)
                self.ballPositions.append(pos)
                //print(ball.x, ball.y)
            }
            startingPositions = ballPositions
        }
        
        endPositions = ending
        for end in ending {
            board.find(x: end.x, y: end.y) {
                let ball = Circle(radius: 50)
                ball.color = self.winColor
                ball.moveTo(self.baseNode)
                self.ends.append(ball)
            }
        }
        

    }
    
    public func keyPressed(key: Key) {
        
        if key == .space {
            solve()
        }
        
        swipe(key)
    }
    
    public func swipe(_ key: Key) {
        let arrows: [Key : EverPos] = [.upArrow : EverPos(0,1), .downArrow : EverPos(0,-1), .rightArrow : EverPos(1,0), .leftArrow : EverPos(-1,0), .w : EverPos(0,1), .s : EverPos(0,-1), .d : EverPos(1,0), .a : EverPos(-1,0)]
        me: if let dir = arrows[key] {
            
            let previousSpots = ballPositions
            
            if balls.first?.__node__.hasActions() == true { break me }
            let newPositions = everMaze.test_move_multiple(EverPos: ballPositions, d: dir)
            for (i, ball) in balls.enumerated() {
                //print(ball.x, ball.y)
                ballPositions[i] = newPositions[i]
                let oldPosition = (ball.x, ball.y)
                let newSpot = newPositions[i]
                self.board.find(x: newSpot.x, y: newSpot.y) {
                    ball.node.moveTo(this.node)
                    ball.x = 0
                    ball.y = 0
                }
                ball.moveTo(self.baseNode)
                let newPosition: (x: Double, y: Double) = (ball.x, ball.y)
                (ball.x, ball.y) = oldPosition
                ball.run(.moveTo(x: newPosition.x, y: newPosition.y).setDuration(speed).setTiming(.ease))
            }
            
            if previousSpots != ballPositions {
                moves += 1
                movesLabel.text = "Moves: \(moves)"
            }
        }
    }
    
    public func touchBegan(x: Double, y: Double) {
        let location = board.tileTapped(x: x, y: y)
        tap_tile(x: location.x, y: location.y)
    }
    
    public func tap_tile(x: Int, y: Int) {
        if x < 0 || y < 0 { return }
        if x >= everMaze.width || y >= everMaze.height { return }
        
        let tileNumber = grid.get(x: x, y: y)
        if tileNumber == 0 {
            grid.set(x: x, y: y, number: 1)
            everMaze.paint(x: x, y: y)
            board.paint(Pos(x, y), .clear)
        } else {
            grid.set(x: x, y: y, number: 0)
            everMaze.erase(x: x, y: y)
            board.paint(Pos(x, y), boardColor)
        }
        
        remove_players()
        different = true
    }
    
}
