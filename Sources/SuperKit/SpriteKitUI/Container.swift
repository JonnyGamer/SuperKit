//
//  Container.swift
//  SpriteKitJSONTesting
//
//  Created by Jonathan Pappas on 8/16/23.
//

import Foundation

enum NodeTypes: String, Codable {
    case Node, Box, Image
    case PhysicsNode, PhysicsBox
    case PhysicsImage, PhysicsImageConnected, PhysicsImageDisconnected
    case Text
    case VStack, HStack
    case Circle, PhysicsCircle
    case Button
    case Padding
    case Window, Toggle, RoundWindow
    case Input
    case Slider
}

class Container: Codable {
    var type: NodeTypes
    var node: Node
    
    static var empty: Container {
        return .init(.init(id: -1))
    }
    
    init(_ node: Node) {
        self.node = node
        self.type = node.type
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let t = try container.decode(NodeTypes.self, forKey: .type)
        self.type = t
        switch t {
        case .Node: self.node = try container.decode(Node.self, forKey: .node)
        case .Box: self.node = try container.decode(Box.self, forKey: .node)
        case .Image: self.node = try container.decode(Image.self, forKey: .node)
        case .PhysicsNode: self.node = try container.decode(PhysicsNode.self, forKey: .node)
        case .PhysicsBox: self.node = try container.decode(PhysicsBox.self, forKey: .node)
        case .PhysicsImage: self.node = try container.decode(PhysicsImage.self, forKey: .node)
        case .PhysicsImageConnected: self.node = try container.decode(PhysicsImageConnected.self, forKey: .node)
        case .PhysicsImageDisconnected: self.node = try container.decode(PhysicsImageDisconnected.self, forKey: .node)
        case .Text: self.node = try container.decode(Text.self, forKey: .node)
        case .VStack: self.node = try container.decode(VStack.self, forKey: .node)
        case .HStack: self.node = try container.decode(HStack.self, forKey: .node)
        case .Circle: self.node = try container.decode(Circle.self, forKey: .node)
        case .PhysicsCircle: self.node = try container.decode(PhysicsCircle.self, forKey: .node)
        case .Button: self.node = try container.decode(Button.self, forKey: .node)
        case .Padding: self.node = try container.decode(Padding.self, forKey: .node)
        case .Window: self.node = try container.decode(Window.self, forKey: .node)
        case .Toggle: self.node = try container.decode(Toggle.self, forKey: .node)
        case .RoundWindow: self.node = try container.decode(RoundWindow.self, forKey: .node)
        case .Input: self.node = try container.decode(Input.self, forKey: .node)
        case .Slider: self.node = try container.decode(Slider<Node>.self, forKey: .node)
        }
    }
}
extension Array where Element == Node {
    func containers() -> [Container] {
        return map { Container($0) }
    }
}
