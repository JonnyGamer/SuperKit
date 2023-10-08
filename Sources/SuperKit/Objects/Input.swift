//
//  Input.swift
//  PappasSpriteKitUITesting
//
//  Created by Jonathan Pappas on 8/25/23.
//

import SpriteKit

class Input: Node, Inputable {
    override var type: NodeTypes { .Input }
    var _lineLocation: Int = 0
    var _characterLocation: Int = 0
    var _selected: Bool = false
    
    var chatDirection: SpeechBubble.ChatDirection = .bottom { didSet { render() } }
    var center: Double = 40 { didSet { render() } }
    // How far away the chat stretch is from the bubble
    var depth: Double = 30 { didSet { render() } }
    // How far away perpendicularily the tip of the chat stretch is from the opening
    var stretch: Double = 20 { didSet { render() } }
    var swap: Bool = false { didSet { render() } }
    // How wide the chat opening is
    var opening: Double = 20 { didSet { render() } }
    
    var cornerRadius: Double = 25
    var hasCornerRadius: Bool = true { didSet { cornerRadius = hasCornerRadius ? 25 : 0; render() }}
    var hasShadow: Bool = false { didSet { render() }}
    
    
    var fillColor: Color = .white { didSet { render() } }
    var textColor: Color = .black { didSet { render() } }
    
    //var cursorLocation: (line: Int, character: Int) = (0, 0)
    // var selector : startingCursorLocation ... endCursorLocation // this will hurt some
    var text : Text2D
    
    @discardableResult
    override init(_ execute: (() -> ())? = nil) {
        self.text = Text2D()
        super.init()
        update()
        s(execute)
        render()
    }
    @discardableResult
    init(defaultText: String,_ execute: (() -> ())? = nil) {
        self.text = Text2D.init(default: defaultText)
        super.init()
        self.cursorLocation = self.text.endOfText()
        update()
        s(execute)
        render()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func update() {
        
    }
    
    private enum CodingKeys: String, CodingKey {
        case text, chatDirection
        case center, depth, stretch, opening, fillColor, textColor, cornerRadius, hasShadow, swap
    }
    
    private func flattenedText() -> String {
        return self.text.text.map({ $0.joined() }).joined(separator: "\n")
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        if !text.text.isEmpty { try container.encode(self.flattenedText(), forKey: .text) }
        if chatDirection != .none { try container.encode(self.chatDirection, forKey: .chatDirection) }
        if cornerRadius != 25 { try container.encode(self.cornerRadius, forKey: .cornerRadius) }
        if center != 40 { try container.encode(self.center, forKey: .center) }
        if depth != 30 { try container.encode(self.depth, forKey: .depth) }
        if stretch != 20 { try container.encode(self.stretch, forKey: .stretch) }
        if opening != 20 { try container.encode(self.opening, forKey: .opening) }
        if fillColor != .white { try container.encode(self.fillColor, forKey: .fillColor) }
        if textColor != .black { try container.encode(self.textColor, forKey: .textColor) }
        if hasShadow { try container.encode(self.hasShadow, forKey: .hasShadow) }
        if swap { try container.encode(self.swap, forKey: .swap) }
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = Text2D(default: try container.decodeIfPresent(String.self, forKey: .text) ?? "(error)")
        if self.text.text.isEmpty {
            self.text.text = [[]]
        }
        
        try super.init(from: decoder)
        
        self.chatDirection = try container.decodeIfPresent(SpeechBubble.ChatDirection.self, forKey: .chatDirection) ?? SpeechBubble.ChatDirection.none
        self.cornerRadius = try container.decodeIfPresent(Double.self, forKey: .cornerRadius) ?? 25
        self.center = try container.decodeIfPresent(Double.self, forKey: .center) ?? 40
        self.depth = try container.decodeIfPresent(Double.self, forKey: .depth) ?? 30
        self.stretch = try container.decodeIfPresent(Double.self, forKey: .stretch) ?? 20
        self.opening = try container.decodeIfPresent(Double.self, forKey: .opening) ?? 20
        self.fillColor = try container.decodeIfPresent(Color.self, forKey: .fillColor) ?? .white
        self.textColor = try container.decodeIfPresent(Color.self, forKey: .textColor) ?? .black
        self.hasShadow = try container.decodeIfPresent(Bool.self, forKey: .hasShadow) ?? false
        self.swap = try container.decodeIfPresent(Bool.self, forKey: .swap) ?? false
        
        update()
        render()
    }
    
}

// Renders the Input Panel
extension Input {
    func render() {
        
        // Remove the previous panel
        removeAllChildren()
        __node__.removeAllChildren()
        
        // node: The multiline text rendered as a node heirarchy
        // nodeSize:
        // cursorPosition: The location the cursor should be rendered at
        let (node, nodeSize, cursorPosition, realHeight) = text.nodes(cursorLocation, textColor: textColor)
        
        // The Speech Bubble itself
        let box = SpeechBubble.init(width: nodeSize.width, height: nodeSize.height, corner: cornerRadius, direction: chatDirection, center: center, depth: depth, stretch: stretch * (swap ? -1 : 1), opening: opening, fillColor: fillColor)
        
        if hasShadow {
            
            let shadowBox = SpeechBubble.init(width: nodeSize.width, height: nodeSize.height, corner: cornerRadius, direction: chatDirection, center: center, depth: depth, stretch: stretch * (swap ? -1 : 1), opening: opening, fillColor: .lightGray, strokeColor: .lightGray)
            let boxFrame = box.calculateAccumulatedFrame()
            shadowBox.xScale *= 0.9
            shadowBox.yScale *= 0.9
            shadowBox.zPosition -= 1000
            shadowBox.anchorAt(.init(x: boxFrame.midX, y: boxFrame.minY), anchor: .init(x: 0.5, y: 0))
            shadowBox.position.y -= 20
            box.addChild(shadowBox)
        }
        
        let goodBox = box
        self.__node__.addChild(goodBox)
        
        
        // The text Lol
        let flattendedText = node.stamp
        flattendedText.centerAt(.init(x: nodeSize.width/2, y: nodeSize.height/2))
        
        goodBox.addChild(flattendedText)
        
        
        if _selected {
            let cursor_ = SKShapeNode.init(rectOf: CGSize.init(width: 5, height: 50), cornerRadius: 2.5)
            cursor_.fillColor = .white
            cursor_.strokeColor = .white
            let cursor = cursor_.stamp
            cursor.colorBlendFactor = 1.0
            cursor.color = .lightGray
            cursor.run(.repeatForever(.sequence([
                .wait(forDuration: 0.4),
                .fadeOut(withDuration: 0.1),
                .wait(forDuration: 0.4),
                .fadeIn(withDuration: 0.1),
            ])))
            //cursor.zPosition = 0.05
            
            //cursor.anchorAt(.init(x: nodeSize.width/2, y: flattendedText.frame.height), anchor: .init(x: 0.5, y: 0.5))
            cursor.anchorAt(.init(x: nodeSize.width/2, y: 0), anchor: .init(x: 0.5, y: 0.5))
            cursor.position.x -= flattendedText.size.width/2
            cursor.position.x += cursorPosition.x
            cursor.position.y += realHeight//flattendedText.size.height //50//3
            cursor.position.y += cursorPosition.y
            cursor.position.y += -10
            
            goodBox.addChild(cursor)
        }
        
        
    }
}
