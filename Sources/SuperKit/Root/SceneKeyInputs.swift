//
//  SceneKeyInputs.swift
//  PappasSpriteKitUITesting
//
//  Created by Jonathan Pappas on 8/25/23.
//

import Foundation

import SpriteKit

extension SKScene {
    func updateTextEditor(_ textEditor: Inputable?, event: NSEvent) {
        guard let textEditor = textEditor else { return }
        let specialKeys = event.modifierFlags.specialKeys()
        
        if event.isARepeat {
            return // No holding keys
        } else if let other = Keyboard.Other.init(rawValue: event.keyCode) {
            
            if other == .delete {
                if specialKeys.contains(.command) {
                    textEditor.commandDelete()
                } else if specialKeys.contains(.option) {
                    textEditor.optionDelete()
                } else {
                    textEditor.delete()
                }
            } else if other == .enter {
                textEditor.enter()
            } else if other == .left {
                if specialKeys.contains(.command) {
                    textEditor.commandLeft()
                } else if specialKeys.contains(.option) {
                    textEditor.optionLeft()
                } else {
                    textEditor.left()
                }
            } else if other == .right {
                if specialKeys.contains(.command) {
                    textEditor.commandRight()
                } else if specialKeys.contains(.option) {
                    textEditor.optionRight()
                } else {
                    textEditor.right()
                }
            } else if other == .up {
                if specialKeys.contains(.command) {
                    textEditor.commandUp()
                } else {
                    textEditor.up()
                }
            } else if other == .down {
                if specialKeys.contains(.command) {
                    textEditor.commandDown()
                } else {
                    textEditor.down()
                }
            }
            
        } else if let normal = Keyboard.Normal.init(rawValue: event.keyCode) {
            if specialKeys.isEmpty {
                let string = Keyboard.Normal.normal[normal]!
                textEditor.typeLetter(string)
            } else if specialKeys.contains(.command) {
                   
            } else if specialKeys.contains(.shift) || specialKeys.contains(.capsLock) {
                let string = Keyboard.Normal.shift[normal]!
                textEditor.typeLetter(string)
            }
        }
        
        // print(textEditor)
        textEditor.render()
    }
}
