//
//  Toggle.swift
//  NextGenerationEditingTool
//
//  Created by Jonathan Pappas on 4/11/23.
//

import SpriteKit

class Toggle: Node {
    
    override var type: NodeTypes { .Toggle }
    
    var _toggling: Bool = false
    
    private func pressed() {
        //__button__.run(.moveBy(x: 0, y: -10, duration: 0.1))
        //__buttonWindow__.__node__.run(.moveBy(x: 0, y: -10, duration: 0.1))
        //__button__.run(.color(self, from: regularColor, to: pressedColor, duration: 0.1, colorize: \.color))
        
        if _toggling { return }
        _toggling = true
        
        self.__on.toggle()
        
        if self.__on {
            circle.centerX(buttonWidth/5)
            let newX = circle.position.x
            circle.centerX(-buttonWidth/5)
            circle.run(.moveTo(x: newX, duration: 0.1).easeInOut()) {
                self.circle.fillColor = .green
                self._toggling = false
            }
            circle.run(SKAction.color(self, from: (0.7, 0.7, 0.7), to: (0.1, 0.9, 0.1), duration: 0.1, colorize: \Toggle.circle.fillColor, \Toggle.circle.strokeColor))
            
        } else {
            circle.centerX(-buttonWidth/5)
            let newX = circle.position.x
            circle.centerX(buttonWidth/5)
            circle.run(.moveTo(x: newX, duration: 0.1).easeInOut()) {
                self.circle.fillColor = .init(white: 0.7, alpha: 1.0)
                self._toggling = false
            }
            circle.run(.color(self, from: (0.1, 0.9, 0.1), to: (0.7, 0.7, 0.7), duration: 0.1, colorize: \Toggle.circle.fillColor, \Toggle.circle.strokeColor))
        }
    }
    
    var buttonWidth: Double
    var shape: SKShapeNode
    var circle: SKShapeNode
    var __on: Bool
    
    enum ToggleStatus: Int {
        case off = 0, on = 1
        func bool() -> Bool { return self == .on ? true : false }
    }
    
    @discardableResult
    convenience init(status: ToggleStatus, height: Double = 50,_ execute: (() -> ())? = nil) {
        self.init(status: status.bool(), height: height, execute)
    }
    
    func setState(_ to: Bool) {
        self.__on = to
        if to {
            circle.fillColor = .init(red: 0.1, green: 0.9, blue: 0.1, alpha: 1.0)
            circle.strokeColor = circle.fillColor
            circle.centerX(buttonWidth/5)
        } else {
            circle.fillColor = .init(white: 0.7, alpha: 1.0)
            circle.strokeColor = circle.fillColor
            circle.centerX(-buttonWidth/5)
        }
    }
    
    @discardableResult
    init(status: Bool, height: Double = 50,_ execute: (() -> ())? = nil) {
        let buttonWidth = height * 1.5
        
        self.buttonWidth = buttonWidth
        shape = SKShapeNode.init(rectOf: .init(width: buttonWidth, height: buttonWidth/1.5), cornerRadius: buttonWidth/3)
        shape.fillColor = .init(white: 0.9, alpha: 1.0)
        shape.strokeColor = shape.fillColor
        
        circle = SKShapeNode.init(circleOfRadius: buttonWidth/4)
        self.__on = status
        
        super.init()
        
        setState(status)
        
        __node__.addChild(shape)
        __node__.addChild(circle)
        
        whenTapped {
            self.pressed()
        }
        
        s(execute)
        update()
    }
    
    private func update() {
        //width = width.d
        //height = height.d
        //color = regularColor.d
        //corner = corner.d
    }
    
    private enum CodingKeys: String, CodingKey {
        case on
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        if width != 0 { try container.encode(self.width, forKey: .width) }
//        if height != 0 { try container.encode(self.height, forKey: .height) }
//        if color != .white { try container.encode(self.color, forKey: .color) }
    }
    
    required public init(from decoder: Decoder) throws {
        fatalError()
//        __sprite__ = SKSpriteNode.init(color: .white, size: .zero)
//        try super.init(from: decoder)
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.width = try container.decodeIfPresent(Double.self, forKey: .width) ?? 0
//        self.height = try container.decodeIfPresent(Double.self, forKey: .height) ?? 0
//        self.color = try container.decodeIfPresent(Color.self, forKey: .color) ?? .white
//
//        update()
    }
}
