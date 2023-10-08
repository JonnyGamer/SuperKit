//
//  Slider.swift
//  PappasSpriteKitUITesting
//
//  Created by Jonathan Pappas on 9/2/23.
//

import SpriteKit

public enum SliderType: String, Codable {
    case line, circle
}

extension EditNode {
    var shape: SKShapeNode { node.__node__ as! SKShapeNode }
}

public class Slider<T: AnyObject>: Node {
    
    override var type: NodeTypes { .Slider }
    
    var minValue: Double = 0.0
    var maxValue: Double = 0.0
    var currentValue: Double = 0.0
    var defaultValue: Double = 0.0
    var sliderType: SliderType = .line
    var keyPath: ReferenceWritableKeyPath<T, Double>
    let nodeEditing: T
    
    var touchMe: Circle!
    func render() {
        if sliderType == .line {
            let distance = maxValue - minValue
            let offset = currentValue - minValue
            let percentage = offset / distance
            touchMe.x = 200 * (percentage - 0.5)
        }
        if sliderType == .circle {
            
            let distance = maxValue - minValue
            let offset = currentValue - minValue
            let percentage = (offset / distance) * 360
            
            let point = pointOnCircle(angle: percentage, radius: 100)
            touchMe.x = point.x
            touchMe.y = point.y
            //touchMe.x = 200 * (percentage - 0.5)
        }
    }
    
    func dragSliderTo() {
        // for the line one
        //touchMe.position.x += by.dx
        if sliderType == .line {
            if touchMe.x < -100 {
                touchMe.x = -100
            }
            if touchMe.x > 100 {
                touchMe.x = 100
            }
            touchMe.y = 0.0
            
            let percentage = (touchMe.x + 100)/200
            let distance = maxValue - minValue
            currentValue = (percentage * distance) + minValue
            
            nodeEditing[keyPath: keyPath] = currentValue// touchMe.x
        }
        if sliderType == .circle {
            let angle = angleOfPointOnCircle(touchMe.__node__.position)
            
            let point = pointOnCircle(angle: angle, radius: 100)
            touchMe.x = point.x
            touchMe.y = point.y
            
            let percentage = angle/360
            let distance = maxValue - minValue
            currentValue = (percentage * distance) + minValue
            
            nodeEditing[keyPath: keyPath] = currentValue
            
            //print(angle)
//            if touchMe.x < -100 {
//                touchMe.x = -100
//            }
//            if touchMe.x > 100 {
//                touchMe.x = 100
//            }
//            touchMe.y = 0.0
//            
//            let percentage = (touchMe.x + 100)/200
//            let distance = maxValue - minValue
//            currentValue = (percentage * distance) + minValue
//            
//            nodeEditing[keyPath: keyPath] = currentValue// touchMe.x
        }
    }
    
    @discardableResult
    public init(_ sliderType: SliderType, minValue: Double, maxValue: Double, defaultValue: Double, editing: ReferenceWritableKeyPath<T, Double>, nodeEditing: T,_ execute: (() -> ())? = nil) {
        //__sprite__ = SKSpriteNode.init(color: .white, size: .ratio(width, height))
        self.minValue = minValue
        self.maxValue = maxValue
        self.sliderType = sliderType
        self.currentValue = nodeEditing[keyPath: editing]// currentValue
        self.keyPath = editing
        self.nodeEditing = nodeEditing
        self.defaultValue = defaultValue
        //let touchMe = SKShapeNode.init(circleOfRadius: 15)
        
        super.init()
        
        if sliderType == .line {
            let boxen = SKShapeNode.init(rectOf: .init(width: 200, height: 10), cornerRadius: 5.0)
            boxen.fillColor = Color.darkBlue.nsColor
            boxen.strokeColor = .black
            boxen.lineWidth = 5
            node.__node__.addChild(boxen)
            self.node {
                Button.init(width: 50, height: 50) {
                    this.x = 150
                    Padding(5) {
                        Text("Reset")
                    }
                    this.whenReleased {
                        self.currentValue = self.defaultValue// 0.0
                        self.render()
                        self.dragSliderTo()
                    }
                }
            }
        }
        
        if sliderType == .circle {
            do {
                let boxen = SKShapeNode.init(circleOfRadius: 100)
                boxen.fillColor = .clear
                boxen.strokeColor = Color.blue.nsColor
                boxen.lineWidth = 5
                node.__node__.addChild(boxen)
            }
            do {
                let boxen = SKShapeNode.init(circleOfRadius: 105)
                boxen.fillColor = .clear
                boxen.strokeColor = .black
                boxen.lineWidth = 5
                node.__node__.addChild(boxen)
            }
            do {
                let boxen = SKShapeNode.init(circleOfRadius: 95)
                boxen.fillColor = .clear
                boxen.strokeColor = .black
                boxen.lineWidth = 5
                node.__node__.addChild(boxen)
            }
            self.node {
                Button.init(width: 100, height: 100) {
                    Padding(10) {
                        Text("Reset")
                    }
                    this.whenReleased {
                        self.currentValue = self.defaultValue// 0.0
                        self.render()
                        self.dragSliderTo()
                    }
                }
            }
        }
        
        self.node {
            self.touchMe = Circle(radius: 15)
        }
        
        touchMe {
            this.shape.fillColor = Color.redSelection.nsColor
            this.shape.strokeColor = .black
            this.shape.lineWidth = 5
            this.draggableButIsBounded()
            this.whenDragged {
                self.dragSliderTo()
            }
        }
        
//        touchMe.fillColor = Color.redSelection.nsColor
//        touchMe.strokeColor = .black// Color.redSelection.nsColor
//        touchMe.lineWidth = 5
//        node.__node__.addChild(touchMe)
        render()
        
        
        
        
        //update()
        s(execute)
    }
//
//    @discardableResult
//    private func _edit<T>(_ newValue: T,_ edit: (() -> ())?, _ path: ReferenceWritableKeyPath<Box, T>...) -> Self {
//        for i in path { self[keyPath: i] = newValue }; return s(edit)
//    }
//
//    public var width: Double = 0 { willSet { __sprite__.size.width = newValue } }
//    /// The width of the box.
//    @discardableResult public func width(_ newValue: Double, edit: (() -> ())? = nil) -> Self { _edit(newValue, edit, \.width) }
//
//    public var height: Double = 0 { willSet { __sprite__.size.height = newValue } }
//    /// The height of the box.
//    @discardableResult public func height(_ newValue: Double, edit: (() -> ())? = nil) -> Self { _edit(newValue, edit, \.height) }
//
//    var _color: _Color { get { color.c() } set { color = newValue.c() } }
//    public var color: Color = .white { willSet { __sprite__.color = newValue.nsColor } }
//    /// The color of the box.
//    @discardableResult public func color(_ newValue: Color, edit: (() -> ())? = nil) -> Self { _edit(newValue, edit, \.color) }
//
    
    private func update() {
//        width = width.d
//        height = height.d
//        color = color.d
    }
    
    private enum CodingKeys: String, CodingKey {
        case minValue, maxValue, sliderType
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        if minValue != 0 { try container.encode(self.minValue, forKey: .minValue) }
        if maxValue != 0 { try container.encode(self.maxValue, forKey: .maxValue) }
        if sliderType != .line { try container.encode(self.sliderType, forKey: .sliderType) }
    }
    
    required public init(from decoder: Decoder) throws {
        fatalError()
//        //__sprite__ = SKSpriteNode.init(color: .white, size: .zero)
//        self.touchMe = SKNode()
//        try super.init(from: decoder)
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.minValue = try container.decodeIfPresent(Double.self, forKey: .minValue) ?? 0
//        self.maxValue = try container.decodeIfPresent(Double.self, forKey: .maxValue) ?? 0
//        self.sliderType = try container.decodeIfPresent(SliderType.self, forKey: .sliderType) ?? .line
//
//        update()
    }
}
