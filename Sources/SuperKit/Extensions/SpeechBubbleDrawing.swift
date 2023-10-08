//
//  SpeechBubbleDrawing.swift
//  PappasSpriteKitUITesting
//
//  Created by Jonathan Pappas on 8/26/23.
//

import SpriteKit

class SpeechBubble: SKNode {
    
    var width: Double { didSet { render() } }
    var height: Double { didSet { render() } }
    var corner: Double { didSet { render() } }
    
    // Where the chat opening is located
    var center: Double = 40 { didSet { render() } }
    // How far away the chat stretch is from the bubble
    var depth: Double = 30 { didSet { render() } }
    // How far away perpendicularily the tip of the chat stretch is from the opening
    var stretch: Double = 20 { didSet { render() } }
    // How wide the chat opening is
    var opening: Double = 20 { didSet { render() } }
    
    var straight: Bool = false { didSet { render() } }
    
    var fillColor: Color = .white { didSet { render() } }
    private var strokeColor: Color? = nil { didSet { render() } }
    
    enum ChatDirection: String, CaseIterable, Codable {
        case top, bottom, left, right, none
        static var random: Self { allCases.randomElement()! }
    }
    
    var chatDirection: ChatDirection = .none
    
    var path = CGMutablePath()
    var bubbleNode: SKShapeNode = SKShapeNode()
    
    init(width: Double, height: Double, corner: Double, direction: ChatDirection, center: Double = 40, depth: Double = 30, stretch: Double = 20, opening: Double = 20, fillColor: Color = .white, strokeColor: Color? = nil) {
        self.width = width
        self.height = height
        self.corner = corner
        self.chatDirection = direction
        self.center = center
        self.depth = depth
        self.stretch = stretch
        self.opening = opening
        self.fillColor = fillColor
        self.strokeColor = strokeColor
        super.init()
        self.render()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func render() {
        
        // Create new Shape Node Container
        path = CGMutablePath()
        bubbleNode.removeFromParent()
        bubbleNode = SKShapeNode()
        
        path.move(to: CGPoint(x: 0, y: corner))
        
        // TODO: - LEFT CHAT COMPLETE -
        if chatDirection == .left {
            // Begin Drawing Bottom Line
            path.addLine(to: CGPoint(x: 0, y: center - opening/2))
            
            // Bottom Line Chat LINE >:)
            if straight || abs(stretch) < 10 { // Make sure if it shall be straight
                path.addLine(to: CGPoint(x: -depth, y: center - 2*stretch))
                path.addLine(to: CGPoint(x: 0, y: center + opening/2))
            } else {
                path.addQuadCurve(to: CGPoint(x: -depth, y:  center - 2*stretch), control: CGPoint(x: -depth, y: center - opening/2))
                path.addQuadCurve(to: CGPoint(x: 0, y: center + opening/2), control: CGPoint(x: -depth, y: center + opening/2))
            }
        }
        
        // Finish Drawing Left Line
        path.addLine(to: CGPoint(x: 0, y: height - corner))
        
        // Top Left Corner
        drawCorner(top: true, right: false)
        
        
        // TODO: - TOP CHAT COMPLETE -
        if chatDirection == .top {
            // Begin Drawing Bottom Line
            path.addLine(to: CGPoint(x: center - opening/2, y: height))
            
            // Bottom Line Chat LINE >:)
            if straight || abs(stretch) < 10 { // Make sure if it shall be straight
                path.addLine(to: CGPoint(x: center - 2*stretch, y: height+depth))
                path.addLine(to: CGPoint(x: center + opening/2, y: height))
            } else {
                path.addQuadCurve(to: CGPoint(x: center - 2*stretch, y: height+depth), control: CGPoint(x: center - opening/2, y: height+depth))
                path.addQuadCurve(to: CGPoint(x: center + opening/2, y: height), control: CGPoint(x: center + opening/2, y: height+depth))
            }
        }
        
        // Finish Drawing Bottom Line
        path.addLine(to: CGPoint(x: width - corner, y: height))
        
        // Top Right Corner
        drawCorner(top: true, right: true)
        
        // TODO: - RIGHT CHAT -
        if chatDirection == .right {
            // Begin Drawing Bottom Line
            path.addLine(to: CGPoint(x: width, y: center + opening/2))
            
            // Bottom Line Chat LINE >:)
            if straight || abs(stretch) < 10 { // Make sure if it shall be straight
                path.addLine(to: CGPoint(x: width+depth, y: center - 2*stretch))
                path.addLine(to: CGPoint(x: width, y: center - opening/2))
            } else {
                path.addQuadCurve(to: CGPoint(x: width+depth, y:  center - 2*stretch), control: CGPoint(x: width+depth, y: center + opening/2))
                path.addQuadCurve(to: CGPoint(x: width, y: center - opening/2), control: CGPoint(x: width+depth, y: center - opening/2))
            }
        }
        
        // Right Line
        path.addLine(to: CGPoint(x: width, y: corner))
        
        // Bottom Right Corner
        drawCorner(top: false, right: true)
        
        
        // TODO: - BOTTOM CHAT COMPLETE -
        if chatDirection == .bottom {
            // Begin Drawing Bottom Line
            path.addLine(to: CGPoint(x: center + opening/2, y: 0))
            
            // Bottom Line Chat LINE >:)
            if straight || abs(stretch) < 10 { // Make sure if it shall be straight
                path.addLine(to: CGPoint(x: center - 2*stretch, y: -depth))
                path.addLine(to: CGPoint(x: center - opening/2, y: 0))
            } else {
                path.addQuadCurve(to: CGPoint(x: center - 2*stretch, y: -depth), control: CGPoint(x: center + opening/2, y: -depth))
                path.addQuadCurve(to: CGPoint(x: center - opening/2, y: 0), control: CGPoint(x: center - opening/2, y: -depth))
            }
        }
        
        // Finish Drawing Bottom Line
        path.addLine(to: CGPoint(x: corner, y: 0))
        
        
        // Bottom Left Corner
        drawCorner(top: false, right: false)
        
        
        // TODO: - END -
        path.closeSubpath()
        
        // Set the path for the bubble node
        bubbleNode.path = path
        
        // Customize the appearance of the bubble
        bubbleNode.fillColor = fillColor.nsColor// SKColor.white
        bubbleNode.strokeColor = strokeColor?.nsColor ?? SKColor.black
        bubbleNode.lineWidth = 8.0
        bubbleNode.lineJoin = .round
        if corner == 0 {
            bubbleNode.lineJoin = .round
        }
        
        // Add the bubble node to the scene
        addChild(bubbleNode)
        
    }
    
    private func drawCorner(top: Bool, right: Bool) {
        let centerX = right ? width - corner : corner
        let centerY = top ? height - corner : corner
        var startAngle = 0.0
        var endAngle = 0.0
        if top, !right {
            startAngle = -.pi
            endAngle = .pi/2
        }
        if top, right {
            startAngle = .pi/2
            endAngle = 0
        }
        if !top, right {
            startAngle = 0
            endAngle = -.pi/2
        }
        if !top, !right {
            startAngle = -.pi/2
            endAngle = -.pi
        }
        if corner > 0 {
            path.addArc(center: .init(x: centerX, y: centerY), radius: corner, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        }
    }
    
    
}

