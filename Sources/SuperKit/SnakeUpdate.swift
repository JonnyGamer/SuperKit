//
//  File.swift
//  
//
//  Created by Jonathan Pappas on 10/31/23.
//

import Foundation

public extension Array where Element: Node {
    func contains<T: Node>(_ this: T) -> Bool {
        return self.contains { $0.id == this.id }
    }
}

public extension Action {
    static func gameLoop(fps: Double, code: @escaping () -> ()) -> Action {
        return Action.sequence([
            .code(code),
            .wait(seconds: 1 / fps)
        ]).repeatForever()
    }
}

public struct Location: Hashable {
    public var x: Int
    public var y: Int
    public func left() -> Location {
        return Location.init(x: x-1, y: y)
    }
    public func right() -> Location {
        return Location.init(x: x+1, y: y)
    }
    public func up() -> Location {
        return Location.init(x: x, y: y+1)
    }
    public func down() -> Location {
        return Location.init(x: x, y: y-1)
    }
    public func moveDirection(_ dir: Direction) -> Location {
        let (dx, dy) = dir.difference()
        return Location.init(x: x + dx, y: y + dy)
    }
    public static var zero: Self { return .init(x: 0, y: 0) }
    public static var unknown: Self { return .init(x: .min, y: .min) }
}

public class Snake {
    public var length: Int = 3
    public var body: [Location] = []
    public var tail: Location { body[0] }
    public var head: Location { body.last! }
    public func removeTail() { body.removeFirst() }
    public func newHead(_ location: Location) { body.append(location) }
    
    public func isCovering(_ location: Location) -> Bool {
        return body.contains(location)
    }
    
    public func gameOver() -> Bool {
        // check if overlapping itself
        if overlappingItself() { return true }
        if offGrid() { return true }
        return false
    }
    
    public func stillExpanding() -> Bool {
        if !overlappingItself(), Set(body).count != body.count {
            return true
        }
        return false
    }
    public func overlappingItself() -> Bool {
        if Set(body).count == 1 { return false }
        return body.firstIndex(of: head)! < body.count-1
    }
    public func offGrid() -> Bool {
        guard let grid = livesOn else { return true }
        if head.x < 0 { return true }
        if head.x >= grid.width { return true }
        if head.y < 0 { return true }
        if head.y >= grid.height { return true }
        return false
    }
    
    private var livesOn: Grid!
    public var color: Color = .white
    public init() {
        body = .init(repeating: .zero, count: length)
    }
    public func place(onGrid: Grid) {
        livesOn = onGrid
    }
    public func gobble() { length += 1 }
    public func didGrow() -> Bool { length > body.count }
    
    public var movingInDirection: Direction = .none
    public func move() {
        // order of operations here is important!
        if didGrow() {
            newHead(head.moveDirection(movingInDirection))
        } else {
            newHead(head.moveDirection(movingInDirection))
            removeTail()
        }
    }
    public func paintSnakeOnGrid() {
        for i in body {
            livesOn.tile(x: i.x, y: i.y) {
                this.color = self.color
            }
        }
    }
    public func pressedKey(_ key: Key, player: Int = 1) {
        let oldMovement = movingInDirection
        if player == 1 {
            if key == .a {
                movingInDirection = .left
            }
            if key == .w {
                movingInDirection = .up
            }
            if key == .s {
                movingInDirection = .down
            }
            if key == .d {
                movingInDirection = .right
            }
            if oldMovement == movingInDirection.opposite() {
                movingInDirection = oldMovement
            }
        }
        if player == 2 {
            if key == .j {
                movingInDirection = .left
            }
            if key == .i {
                movingInDirection = .up
            }
            if key == .k {
                movingInDirection = .down
            }
            if key == .l {
                movingInDirection = .right
            }
            if oldMovement == movingInDirection.opposite() {
                movingInDirection = oldMovement
            }
        }
    }
}

public extension Array {
    func only(_ element: Element) -> Bool where Element: Hashable & Equatable {
        return Set(self) == [element]
    }
}

public enum Direction {
    case up, down, left, right, none
    public func difference() -> (dx: Int, dy: Int) {
        switch self {
        case .down: return (0,-1)
        case .up: return (0,1)
        case .left: return (-1,0)
        case .right: return (1,0)
        case .none: return (0,0)
        }
    }
    public func opposite() -> Self {
        switch self {
        case .down: return .up
        case .up: return .down
        case .left: return .right
        case .right: return .left
        case .none: return .none
        }
    }
}

public class Tile: Box {
    public var column: Int
    public var row: Int
//    var box: Grid?
    
    public init(column: Int, row: Int, width: Double, height: Double,_ execute: (() -> ())? = nil) {
        self.column = column
        self.row = row
        super.init(width: 100, height: 100)
        
        s(execute)
    }
    
//    public var left: Tile {
//
//    }
    
    required public init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    public var value: String = ""
    func isEmtpy() -> Bool {
        return value.isEmpty
    }
}

public class Grid: Node {

    public let width: Int
    public let height: Int
    public var allLocations: [Location] = []
    
    public func random() -> Location {
        return Location.init(x: Int.random(in: 0..<width), y: Int.random(in: 0..<height))
    }
    public func random(not: [Location]) -> Location {
        return Set(allLocations).subtracting(not).randomElement()!
    }
    
    private var tiles: [Tile] = []
    
    public func tile(x: Int, y: Int,_ edit: @escaping () -> ()) {
        if x < 0 { return }
        if x >= width { return }
        if y < 0 { return }
        if y >= height { return }
        tiles[y*width + x].self {
            edit()
        }
    }
    
    public func tileValue(x: Int, y: Int) -> String {
        if x < 0 { return "" }
        if x >= width { return "" }
        if y < 0 { return "" }
        if y >= height { return "" }
        return tiles[y*width + x].value
    }
    
    public override func removeAllChildren() {
        allTiles {
            this.removeAllChildren()
        }
    }
    
    public func allTiles(_ with: @escaping () -> ()) {
        for i in tiles {
            i {
                with()
            }
        }
    }
    
    public init(width: Int, height: Int,_ execute: (() -> ())? = nil) {
        self.width = width
        self.height = height
        
        super.init()
        
        self {
            for y in 0..<height {
                for x in 0..<width {
                    let o = Tile.init(column: x, row: y, width: 100, height: 100)
                    o {
                    //let o = Box.init(width: 100, height: 100) {
                        this.x = Double(x)*100
                        this.y = Double(y)*100
                        self.allLocations.append(Location(x: x, y: y))
                    }
                    self.tiles.append(o)
                }
            }
        }
        //s(execute)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}


public class SnakeScene: Scene {

    let snake = Snake()
    let grid = Grid.init(width: 10, height: 10)
    
    public init() {
        
    }
    
    public func began() {
        
        backgroundColor = .black
        
        grid {
            this.keepInsideScreen()
            this.scale = 0.9
            this.centerScreen()
        }
        grid.allTiles {
            this.color = .black
        }
        grid.tile(x: 0, y: 0) {
            this.color = .redSelection
        }
        
        Box.init(width: 920, height: 920) {
            this.color = .white
            this.layer = -1
            this.centerScreen()
        }
        
        Box.init(width: 920, height: 920) {
            this.color = .lightGray
            this.layer = -2
            this.centerScreen()
            this.y -= 12.5
            this.run(.circle(radius: 12.5).setDuration(5).repeatForever())
        }
        Box.init(width: 920, height: 920) {
            this.color = .darkGray
            this.layer = -3
            this.centerScreen()
            this.y -= 25
            this.run(.circle(radius: 25).setDuration(5).repeatForever())
        }
        
        snake.place(onGrid: grid)
        
        let o = Node()
        o.run(.gameLoop(fps: 10, code: updateSnake))
    }
    
    public func keyPressed(key: Key) {
        snake.pressedKey(key)
        
        if key == .space {
            if snake.gameOver() {
                presentScene {
                    SnakeScene()
                }
            }
        }
    }
    
    public func updateSnake() {
        let oldTail = snake.tail
        
        if snake.gameOver() {
            return
        }
        
        if !snake.stillExpanding() {
            grid.tile(x: oldTail.x, y: oldTail.y) {
                this.color = .black
            }
        }
        
        snake.move()
        
        if snake.gameOver() {
            return
        }
        
//        grid.allTiles {
//            this.color = .black
//        }
        if snake.head == appleLocation {
            appleLocation = .unknown
            snake.gobble()
        }
        if appleLocation == .unknown {
            randomApple()
        }
        grid.tile(x: snake.head.x, y: snake.head.y) {
            this.color = .white
        }
        //snake.paintSnakeOnGrid()
        
    }
    
    var appleLocation: Location = Location.unknown
    func randomApple() {
        appleLocation = grid.random(not: snake.body)
        grid.tile(x: appleLocation.x, y: appleLocation.y) {
            this.color = .redSelection
        }
    }

}
