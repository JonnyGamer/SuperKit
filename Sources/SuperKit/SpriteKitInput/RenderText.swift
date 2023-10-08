//
//  RenderText.swift
//  PappasSpriteKitUITesting
//
//  Created by Jonathan Pappas on 8/25/23.
//

import SpriteKit

let kerning: [String : CGPoint] = [
    "'" : CGPoint.init(x: 0, y: 20),
    "\"" : CGPoint.init(x: 0, y: 20),
    "," : CGPoint.init(x: -5, y: -7),
    "g" : CGPoint.init(x: 0, y: -7),
    "p" : CGPoint.init(x: 0, y: -7),
    "q" : CGPoint.init(x: 0, y: -12),
    "j" : CGPoint.init(x: 0, y: -5),
    "y" : CGPoint.init(x: 0, y: -7),
    "(" : CGPoint.init(x: 0, y: -3),
    ")" : CGPoint.init(x: 0, y: -5),
    "-" : CGPoint.init(x: 0, y: 15),
    ">" : CGPoint.init(x: 0, y: 10),
    "<" : CGPoint.init(x: 0, y: 10),
    "+" : CGPoint.init(x: 0, y: 10),
    "qu" : CGPoint.init(x: -10, y: 0),
]


extension Text2D {
    func nodes(_ at: (line: Int, character: Int), textColor: Color) -> (SKNode, CGSize, cursorPos: CGPoint, trueHeight: CGFloat) {
        
        let holder = SKNode()
        let scale: CGFloat = 0.5
        let lineSpacing: CGFloat = 120 * scale
        let letterSpacing: Double = 7
        
        var size = CGSize.init(width: 0, height: 0)
        var cursorPosition: CGPoint = .zero
        var xPosition: CGFloat = 0
        
        func updateCursor(_ y: Int) {
            cursorPosition = CGPoint(x: xPosition - 5, y: -CGFloat(y)*lineSpacing)
        }
        
        for (y, line) in text.enumerated() {
            
            let empty = SKSpriteNode.init(color: .clear, size: CGSize.init(width: 1, height: 43))
            empty.position.y = -CGFloat(y)*lineSpacing + empty.size.height/2
            holder.addChild(empty)
            
            xPosition = 0
            if at == (y,0) {
                updateCursor(y)
            }
            var previousLetter = ""
            
            for (x, character) in line.enumerated() {
                
                var name = character
                if name == " " {
                    let empty = SKSpriteNode.init(color: .clear, size: CGSize.init(width: 20, height: 43))
                    empty.position.y = -CGFloat(y)*lineSpacing + empty.size.height/2
                    empty.position.x = xPosition + letterSpacing//letter.frame.maxX + 10//-CGFloat(y)*lineSpacing + empty.size.height/2
                    holder.addChild(empty)
                    xPosition += empty.size.width + letterSpacing
                    if at == (y,x+1) {
                        updateCursor(y)
                    }
                    continue
                }
                else if name.first?.isUppercase == true { name += "-cap" }
                else if name == "&" { name = "and" }
                else if name == "~" { name = "around" }
                else if name == ":" { name = "colon" }
                else if name == "," { name = "comma" }
                else if name == "=" { name = "equal" }
                else if name == ">" { name = "greater" }
                else if name == "<" { name = "less" }
                else if name == "%" { name = "percent" }
                else if name == "." { name = "period" }
                else if name == "!" { name = "point" }
                else if name == "?" { name = "question" }
                else if name == "*" { name = "times" }
                else if name == "\"" { name = "quote" }
                else if name == "'" { name = "semiquote" }
                
                let letter = SKSpriteNode.init(imageNamed: name)
                letter.colorBlendFactor = 1.0
                letter.color = textColor.nsColor// .black
                letter.setScale(scale)
                letter.anchorPoint = .zero
                
                letter.position = CGPoint(x: xPosition, y: -CGFloat(y)*lineSpacing)
                
                holder.addChild(letter)
                
                if let kern = kerning[character] {
                    letter.position.x += kern.x
                    letter.position.y += kern.y
                }
                if previousLetter != "" {
                    if let kern = kerning[previousLetter + character] {
                        letter.position.x += kern.x
                        letter.position.y += kern.y
                    }
                }
                
                xPosition = letter.frame.maxX + letterSpacing
                
                //print("-", letter.position.y, y, lineSpacing, kerning[character]?.y ?? 0)
                
                if at == (y,x+1) {
                    updateCursor(y)
                }
                
                previousLetter = character
            }
            
            size.width = max(size.width, xPosition + 50)
        }
        
        size.height = max(100, CGFloat(endOfText().line+2) * lineSpacing - 30)
        
        return (holder, size, cursorPosition, CGFloat(endOfText().line+1) * lineSpacing)
    }
}
