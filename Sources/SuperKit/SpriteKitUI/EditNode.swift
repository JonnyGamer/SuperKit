//
//  EditNode.swift
//  PappasSpriteKitUITesting
//
//  Created by Jonathan Pappas on 8/19/23.
//

import Foundation

public var this: EditNode {
    EditNode(node: stack.last ?? root)
}

public class EditNode {
    public var node: Node
    //var image: Image { node as! Image }
    //var box: Box { node as! Box }
    public var physics: Physics { node as! Physics }
    var text: Text { node as! Text }
    var vstack: VStack { node as! VStack }
    var hstack: HStack { node as! HStack }
    var toggle: Toggle { node as! Toggle }
    var button: Button { node as! Button }
    var input: Input { node as! Input }
    
    fileprivate init(node: Node) { self.node = node }
    
    public func centerScreen() { node.__node__.centerAt(.midPoint) }
    public func keepInsideScreen() { node.__node__.keepInside(.screenSize) }
    public func removeAllChildren() { node.removeAllChildren() }
    
    public var x: Double { get { node.x } set { node.x = newValue } }
    public var y: Double { get { node.y } set { node.y = newValue } }
    public var xScale: Double { get { node.xScale } set { node.xScale = newValue } }
    public var yScale: Double { get { node.yScale } set { node.yScale = newValue } }
    public var scale: Double { get { .nan } set { node.setScale(newValue) } }
    var defaultScale: Double { get { node.defaultScale } set { node.defaultScale = newValue } }
    public var layer: Double { get { node.layer } set { node.layer = newValue } }
    public var name: String { get { node.name } set { node.name = newValue } }
    public var rotation: Double { get { node.rotation } set { node.rotation = newValue } }
    public var visibility: Double { get { node.visibility } set { node.visibility = newValue } }
    
    public var minY: Double { get { node.minY } set { node.minY = newValue } }
    public var maxY: Double { get { node.maxY } set { node.maxY = newValue } }
    public var minX: Double { get { node.minX } set { node.minX = newValue } }
    public var maxX: Double { get { node.maxX } set { node.maxX = newValue } }
    
    
    public var value: String {
        get { (node as? Tile)?.value ?? "" }
        set { (node as? Tile)?.value = newValue }
    }
    public var row: Int {
        get { (node as? Tile)?.row ?? 0 }
    }
    public var column: Int {
        get { (node as? Tile)?.column ?? 0 }
    }
    public var tileScale: Double {
        get { (node as? Board)?.tileScale ?? 1 }
    }
    
    public var width: Double {
        get { (node as? Size)?.width ?? .nan }
        set { (node as? Size)?.width = newValue }
    }
    public var height: Double {
        get { (node as? Size)?.height ?? .nan }
        set { (node as? Size)?.height = newValue }
    }
    public var color: Color {
        get { (node as? Colorable)?._color.c() ?? .white }
        set { (node as? Colorable)?._color = newValue.c() }
    }
    
    public var colorPercentage: Double {
        get { (node as? Image)?.colorPercentage ?? .nan }
        set { (node as? Image)?.colorPercentage = newValue }
    }
    public var image: String {
        get { (node as? Image)?.image ?? "Warning: this is not an image" }
        set { (node as? Image)?.image = newValue }
    }
    
    public func whenTapped(_ run: @escaping () -> ()) { node.whenTapped(run) }
    public func whenReleased(_ run: @escaping () -> ()) { node.whenReleased(run) }
    public func whenDragged(_ run: @escaping () -> ()) { node.whenDragged(run) }
    public func whenCancelled(_ run: @escaping () -> ()) { node.whenCancelled(run) }
    public func whenKeyPressed(_ run: @escaping () -> ()) { node.whenKeyPressed(run) }
    public func whenKeyReleased(_ run: @escaping () -> ()) { node.whenKeyReleased(run) }
    public func update(_ run: @escaping () -> ()) { node.update(run) }
    public func whenSelected(_ run: @escaping () -> ()) { node.whenSelected(run) }
    public func whenDeselected(_ run: @escaping () -> ()) { node.whenDeselected(run) }
    
    public func isTouching(_ thisNode: Node) -> Bool {
        node.isTouching(thisNode)
    }
    
    public func removeProperty(_ property: Property) { node.removePropety(property) }
    
    public func draggable() {
        node.makeDraggable()
    }
    public func draggableButIsBounded() {
        node.makeDraggableIsBounded()
    }
    
    public func editable() {
        node.makeEditable()
    }
    
    public var obeysGravity: Bool {
        get { (node as? Physics)?.obeysGravity ?? false }
        set { (node as? Physics)?.obeysGravity = newValue }
    }
    public var stationary: Bool {
        get { (node as? Physics)?.stationary ?? true }
        set { (node as? Physics)?.stationary = newValue }
    }
    public var pinned: Bool {
        get { (node as? Physics)?.pinned ?? true }
        set { (node as? Physics)?.pinned = newValue }
    }
    public var canSpin: Bool {
        get { (node as? Physics)?.canSpin ?? false }
        set { (node as? Physics)?.canSpin = newValue }
    }
    public var friction: Double {
        get { (node as? Physics)?.friction ?? .nan }
        set { (node as? Physics)?.friction = newValue }
    }
    public var drag: Double {
        get { (node as? Physics)?.drag ?? .nan }
        set { (node as? Physics)?.drag = newValue }
    }
    public var bounciness: Double {
        get { (node as? Physics)?.bounciness ?? .nan }
        set { (node as? Physics)?.bounciness = newValue }
    }
    public var xVelocity: Double {
        get { (node as? Physics)?.xVelocity ?? .nan }
        set { (node as? Physics)?.xVelocity = newValue }
    }
    public var yVelocity: Double {
        get { (node as? Physics)?.yVelocity ?? .nan }
        set { (node as? Physics)?.yVelocity = newValue }
    }
    public var rotationalVelocity: Double {
        get { (node as? Physics)?.rotationalVelocity ?? .nan }
        set { (node as? Physics)?.rotationalVelocity = newValue }
    }
    
    
}


//var box: Box {
//    stack.last!.box!
//}
//var image: Box {
//    stack.last!.image!
//}
