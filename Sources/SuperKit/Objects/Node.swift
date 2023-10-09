//
//  Node.swift
//  SpriteKitJSONTesting
//
//  Created by Jonathan Pappas on 8/16/23.
//

import SpriteKit

public class Node: Codable {
    @objc private(set) public var __node__: SKNode = SKNode()
    public var node: Node { return self }
    public var id: Int { willSet {
        __node__.referenceID = newValue
    } }
    var type: NodeTypes { .Node }
    var hidden = false
    
    var editable = false
    func makeEditable() {
        editable = true
        makeDraggable()
    }
    
    @discardableResult
    public init(_ execute: (() -> ())? = nil) {
        self.id = Everything.maxId()
        Everything.add(self)
        s(execute)
        addToStack(self)
        update()
        sayHello(self)
    }
    
    init(DONTSAVE: Bool) {
        self.id = -100
        addToStack(self)
        update()
        sayHello(self)
    }
    
    public init(id: Int) {
        self.id = id
        Everything.add(self)
        update()
        sayHello(self)
    }
    
    deinit {
        sayGoodbye(self)
    }
    
    //    @discardableResult public func Node(_ execute: (() -> ())? = nil) -> Node { s { PappasSpriteKitUITesting.Node.init(execute) } }
    //    @discardableResult public func Box(width: Double, height: Double,_ execute: (() -> ())? = nil) -> Node {
    //        s { PappasSpriteKitUITesting.Box.init(width: width, height: height, execute) }
    //    }
    //    @discardableResult public func Image(_ named: String,_ execute: (() -> ())? = nil) -> Node {
    //        s { PappasSpriteKitUITesting.Image(named, execute) }
    //    }
    //    @discardableResult public func Text(_ text: String,_ execute: (() -> ())? = nil) -> Node {
    //        s { PappasSpriteKitUITesting.Text(text, execute) }
    //    }
    //    @discardableResult public func Button(width: Double, height: Double,_ execute: (() -> ())? = nil) -> Node {
    //        s { PappasSpriteKitUITesting.Button(width: width, height: height, execute) }
    //    }
    
    @discardableResult
    private func _edit<T>(_ newValue: T,_ edit: (() -> ())?, _ path: ReferenceWritableKeyPath<Node, T>...) -> Self {
        // Assign the value. However, determine if this is `NOW` or a `DELAYED` action
        for i in path {
            self[keyPath: i] = newValue
        }
        s(edit) // post edit closure
        return self
    }
    
    /// The x-coordinate.
    public var x: Double {
        get { __node__.position.x }
        set { __node__.position.x = newValue }
    }
    
    /// The y-coordinate.
    public var y: Double {
        get { __node__.position.y }
        set { __node__.position.y = newValue }
    }
    
    private var width: Double { (self as? Size)?.width ?? .nan }
    private var height: Double { (self as? Size)?.height ?? .nan }
    
    /// Determine if two nodes are overlapping
    public func overlaps(_ node: Node) -> Bool {
        let obj1 = self; let obj2 = node
        return obj1.x < obj2.x + obj2.width &&
             obj1.x + obj1.width > obj2.x &&
             obj1.y < obj2.y + obj2.height &&
             obj1.y + obj1.height > obj2.y;
    }
    
    public var minY: Double {
        get { y - height/2 }
        set { y = newValue + height/2 }
    }
    public var maxY: Double {
        get { y + height/2 }
        set { y = newValue - height/2 }
    }
    public var minX: Double {
        get { x - width/2 }
        set { x = newValue + width/2 }
    }
    public var maxX: Double {
        get { x + width/2 }
        set { x = newValue - width/2 }
    }
    
    //var x: Double = 0 { willSet { __node__.position.x = newValue } }
    
    //@discardableResult public func x(_ newValue: Double, edit: (() -> ())? = nil) -> Self { _edit(newValue, edit, \.x) }
    
    //var y: Double = 0 { willSet { __node__.position.y = newValue } }
    //@discardableResult public func y(_ newValue: Double, edit: (() -> ())? = nil) -> Self { _edit(newValue, edit, \.y) }
    
    /// A higher `layer` means this node is *above* lower ones.
    public var layer: Double = 0 { willSet { __node__.zPosition = newValue } }
    //@discardableResult public func layer(_ newValue: Double, edit: (() -> ())? = nil) -> Self { _edit(newValue, edit, \.layer) }
    
    /// Make your node wider or skinnier. A negative xScale will make a mirror image.
    var xScale: Double = 1.0 { willSet { __node__.xScale = newValue } }
    // @discardableResult public func xScale(_ newValue: Double, edit: (() -> ())? = nil) -> Self { _edit(newValue, edit, \.xScale) }
    
    var flipped: Bool { get { self.xScale < 0 } set { self.xScale = abs(self.xScale) * (newValue ? -1 : 1) } }
    
    /// Make your node taller or shorter. A negative yScale will make a mirror image upsidedown.
    var yScale: Double = 1.0 { willSet { __node__.yScale = newValue } }
    /// Make your node taller or shorter. A negative yScale will make a mirror image upsidedown.
    //@discardableResult public func yScale(_ newValue: Double, edit: (() -> ())? = nil) -> Self { _edit(newValue, edit, \.yScale) }
    
    var scalePreserveFlip: Double { get { if abs(xScale) == yScale { return yScale }; return .nan } set {
        yScale = newValue
        xScale = abs(newValue) * (flipped ? -1 : 1)
    } }
    
    var defaultScale: Double = 1.0
    /// The scale multiplies the size of the node. A bigger scale means the node apears bigger.
    public var scale: Double { get { if xScale == yScale { return yScale }; return .nan } set { setScale(newValue) } }
    /// The scale multiplies the size of the node. A bigger scale means the node apears bigger.
    @discardableResult public func setScale(_ newValue: Double, edit: (() -> ())? = nil) -> Self { _edit(newValue, edit, \.xScale, \.yScale) }
    
    /// Give your node a name so you can identify it later.
    public var name: String = "" { willSet { __node__.name = newValue } }
    // @discardableResult public func name(_ newValue: String, edit: (() -> ())? = nil) -> Self { _edit(newValue, edit, \.name) }
    
    /// Rotation is marked in degrees. To turn your node upside-down, set `rotation` to 180.
    public var rotation: Double = 0.0 { willSet { __node__.zRotation = newValue.toRadians() } }
    // @discardableResult public func rotation(_ newValue: Double, edit: (() -> ())? = nil) -> Self { _edit(newValue, edit, \.rotation) }
    
    /// The visibility percentage of your node. To make your node invisible, set `visibility` to 0.
    var visibility: Double = 100.0 { willSet { __node__.alpha = newValue/100 } }
    // @discardableResult public func visibility(_ newValue: Double, edit: (() -> ())? = nil) -> Self { _edit(newValue, edit, \.visibility) }
    
    
    public func isTouching(_ thisNode: Node) -> Bool {
        return __node__.physicsBody?.allContactedBodies().contains(where: { $0.node === thisNode.__node__ }) ?? false
    }
    
    // This is the most magical thing ever
    //private var properties: [Property : [CodingActions]] = [:]
    private(set) var properties: [Property : [(Event) -> ()]] = [:]
    @discardableResult
    private func addProperty(_ property: Property,_ run: @escaping (Event) -> ()) -> Self {
        _addingPropety(property)
        properties.add(property, with: [run])
        return self
    }
    @discardableResult
    private func addProperty(_ property: Property,_ run: @escaping () -> ()) -> Self {
        _addingPropety(property)
        properties.add(property, with: [{ _ in run() }])
        return self
    }
    private func runProperty(_ property: Property,_ event: Event?) {
        eventStack.append(event ?? Event())
        s {
            self.properties[property]?.forEach({ $0(event ?? Event()) })
        }
        if !eventStack.isEmpty {
            eventStack.removeLast()
        }
    }
    
    public func removePropety(_ property: Property) {
        _removingProperty(property)
        self.properties[property] = nil
    }
    
    private func _addingPropety(_ property: Property) {
        if property == .whenKeyPressed {
            if trueScene.keysPressedNodes.contains(where: { $0 === self }) { return }
            trueScene.keysPressedNodes.append(self)
        } else if property == .whenKeyReleased {
            if trueScene.keysReleasedNodes.contains(where: { $0 === self }) { return }
            trueScene.keysReleasedNodes.append(self)
        } else if property == .update {
            if trueScene.updateNodes.contains(where: { $0 === self }) { return }
            trueScene.updateNodes.append(self)
        }
    }
    private func _removingProperty(_ property: Property) {
        if property == .whenKeyPressed {
            trueScene.keysPressedNodes.removeAll(where: { $0 === self })
        } else if property == .whenKeyReleased {
            trueScene.keysReleasedNodes.removeAll(where: { $0 === self })
        } else if property == .update {
            trueScene.updateNodes.removeAll(where: { $0 === self })
        }
    }
    
    public func makeDraggable() {
        node.whenDragged { event in
            this.x += event.dx
            this.y += event.dy
        }
    }
    
    public func makeDraggableIsBounded() {
        node.whenDragged { event in
            //this.x += event.dx
            //this.y += event.dy
            if this.node.parent === root {
                this.x = event.x
                this.y = event.y
            } else {
                let newPoint = root.__node__.convert(.init(x: event.x, y: event.y), to: this.node.parent!.__node__)
                this.x = newPoint.x
                this.y = newPoint.y
            }
        }
    }
    
    @discardableResult public func whenTapped(_ run: @escaping () -> ()) -> Self { addProperty(.whenTapped, run) }
    @discardableResult public func whenTapped(_ run: @escaping (Event) -> ()) -> Self { addProperty(.whenTapped, run) }
    public func tapped(_ event: Event? = nil) {
        runProperty(.whenTapped, event)
    }
    @discardableResult public func whenDragged(_ run: @escaping () -> ()) -> Self { addProperty(.whenDragged, run) }
    @discardableResult public func whenDragged(_ run: @escaping (Event) -> ()) -> Self { addProperty(.whenDragged, run) }
    public func dragged(_ event: Event? = nil) {
        runProperty(.whenDragged, event)
    }
    
    @discardableResult public func whenReleased(_ run: @escaping () -> ()) -> Self { addProperty(.whenReleased, run) }
    @discardableResult public func whenReleased(_ run: @escaping (Event) -> ()) -> Self { addProperty(.whenReleased, run) }
    public func released(_ event: Event? = nil) {
        runProperty(.whenReleased, event)
    }
    @discardableResult public func whenCancelled(_ run: @escaping () -> ()) -> Self { addProperty(.whenCancelled, run) }
    @discardableResult public func whenCancelled(_ run: @escaping (Event) -> ()) -> Self { addProperty(.whenCancelled, run) }
    public func cancelled(_ event: Event? = nil) {
        runProperty(.whenCancelled, event)
    }
    
    @discardableResult public func whenKeyPressed(_ run: @escaping () -> ()) -> Self { addProperty(.whenKeyPressed, run) }
    @discardableResult public func whenKeyPressed(_ run: @escaping (Event) -> ()) -> Self { addProperty(.whenKeyPressed, run) }
    public func keyPressed(_ event: Event? = nil) {
        runProperty(.whenKeyPressed, event)
    }
    
    @discardableResult public func whenKeyReleased(_ run: @escaping () -> ()) -> Self { addProperty(.whenKeyReleased, run) }
    @discardableResult public func whenKeyReleased(_ run: @escaping (Event) -> ()) -> Self { addProperty(.whenKeyReleased, run) }
    public func keyReleased(_ event: Event? = nil) {
        runProperty(.whenKeyReleased, event)
    }
    
    @discardableResult public func update(_ run: @escaping () -> ()) -> Self { addProperty(.update, run) }
    @discardableResult public func update(_ run: @escaping (Event) -> ()) -> Self { addProperty(.update, run) }
    public func updateNode(_ event: Event? = nil) {
        runProperty(.update, event)
    }
    
    
    @discardableResult public func whenSelected(_ run: @escaping () -> ()) -> Self { addProperty(.whenSelected, run) }
    @discardableResult public func whenSelected(_ run: @escaping (Event) -> ()) -> Self { addProperty(.whenSelected, run) }
    public func select(_ event: Event? = nil) {
        runProperty(.whenSelected, event)
    }
    @discardableResult public func whenDeselected(_ run: @escaping () -> ()) -> Self { addProperty(.whenDeselected, run) }
    @discardableResult public func whenDeselected(_ run: @escaping (Event) -> ()) -> Self { addProperty(.whenDeselected, run) }
    public func deselect(_ event: Event? = nil) {
        runProperty(.whenSelected, event)
    }
    
    
    
    private(set) public var parent: Node?
    
    internal(set) public var children: [Node] = []
    public func add(_ child: Node) {
        if child.parent != nil {
            print("Warning: This child already has a parent"); return
        }
        child.parent = self
        children.append(child)
        __node__.addChild(child.__node__)
        if __node__.scene != nil {
            totalNodes += child.__node__.totalChildrenRecursive() + 1
        }
    }
    
    public func moveTo(_ newParent: Node) {
        if parent == nil { print("Warning: This node does not have a parent"); return }
        __node__.move(toParent: newParent.__node__)
        parent?.children.removeAll(where: { $0 === self })
        parent = newParent
        parent?.children.append(self)
    }
    
    public func listChildrenRecursive() -> [Node] {
        return children + children.map { $0.listChildrenRecursive() }.flatMap { $0 }
    }
    
    public func remove() {
        parent?.children.removeAll(where: { $0 === self })
        self.__node__.removeFromParent()
        parent = nil
    }
    public func removeAllChildren() {
        for i in children {
            i.remove()
        }
    }
    
    private func update() {
        x = x.d
        y = y.d
        layer = layer.d
        xScale = xScale.d
        yScale = yScale.d
        name = name.d
        rotation = rotation.d
        visibility = visibility.d
        id = id.d
    }
    
    private enum CodingKeys: String, CodingKey {
        case x, y, xScale, yScale, name, layer, children, rotation, visibility
        case editable, defaultScale
        // case properties, id
        case root
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if x != 0 { try container.encode(self.x, forKey: .x) }
        if y != 0 { try container.encode(self.y, forKey: .y) }
        if layer != 0 { try container.encode(self.layer, forKey: .layer) }
        if xScale != 1 { try container.encode(self.xScale, forKey: .xScale) }
        if yScale != 1 { try container.encode(self.yScale, forKey: .yScale) }
        if name != "" { try container.encode(self.name, forKey: .name) }
        if rotation != 0 { try container.encode(self.rotation, forKey: .rotation) }
        if visibility != 100 { try container.encode(self.visibility, forKey: .visibility) }
        if !children.isEmpty { try container.encode(self.children.filter({ !$0.hidden }).containers(), forKey: .children) }
        if editable { try container.encode(self.editable, forKey: .editable) }
        if defaultScale != 1.0 { try container.encode(self.defaultScale, forKey: .defaultScale) }
        
        if self.id < 0 { try container.encode(true, forKey: .root) }
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        //self.id = try container.decode(Int.self, forKey: .id)
        let isRoot = try container.decodeIfPresent(Bool.self, forKey: .root) ?? false
        if isRoot {
            self.id = -1
        } else {
            self.id = Everything.maxId()
        }
        //self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? Everything.maxId()
        
        self.x = try container.decodeIfPresent(Double.self, forKey: .x) ?? 0
        self.y = try container.decodeIfPresent(Double.self, forKey: .y) ?? 0
        self.layer = try container.decodeIfPresent(Double.self, forKey: .layer) ?? 0
        self.xScale = try container.decodeIfPresent(Double.self, forKey: .xScale) ?? 1
        self.yScale = try container.decodeIfPresent(Double.self, forKey: .yScale) ?? 1
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.rotation = try container.decodeIfPresent(Double.self, forKey: .rotation) ?? 0
        self.visibility = try container.decodeIfPresent(Double.self, forKey: .visibility) ?? 100
        self.defaultScale = try container.decodeIfPresent(Double.self, forKey: .defaultScale) ?? 1.0
        
        self.editable = try container.decodeIfPresent(Bool.self, forKey: .editable) ?? false
        //self.properties = try container.decodeIfPresent([Property : [CodingActions]].self, forKey: .properties) ?? [:]
        if editable {
            makeEditable()
        }
        
        
        let containers = try container.decodeIfPresent([Container].self, forKey: .children) ?? []
        for i in containers {
            if node.id == -1 {
                root.add(i.node)
            } else {
                add(i.node)
            }
        }
        
        update()
        if !isRoot {
            Everything.add(self)
        }
    }
    
    @discardableResult
    func s(_ e: (() -> ())?) -> Self {
        if let e = e {
            stack.append(self)
            e()
            if !stack.isEmpty {
                stack.removeLast()
            }
        }
        return self
    }
    
    @discardableResult public func callAsFunction(_ edit: @escaping () -> ()) -> Self {
        s(edit)
        return self
    }
    
    var copy: Node {
        let encode: Container = _decode(_encode(Container(self)))
        return encode.node
    }
    
}
