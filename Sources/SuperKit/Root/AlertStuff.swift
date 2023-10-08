//
//  AlertStuff.swift
//  PappasSpriteKitUITesting
//
//  Created by Jonathan Pappas on 8/31/23.
//

import SpriteKit
import AppKit

func inputAlert(_ inputMessage: String = "Enter a Name") -> String? {
    let alert = NSAlert()
    alert.messageText = inputMessage
    alert.addButton(withTitle: "OK")
    alert.addButton(withTitle: "Cancel")

    let textField = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
    textField.stringValue = ""
    alert.accessoryView = textField

    let response = alert.runModal()

    if response == .alertFirstButtonReturn {
        let enteredString = textField.stringValue
        return enteredString
    }
    return nil
}

//
//func showTextInputAlert(completion: @escaping (String?) -> Void) {
//    let alert = NSAlert()
//    alert.messageText = "Enter a String"
//    alert.addButton(withTitle: "Submit")
//    alert.addButton(withTitle: "Cancel")
//    
//    let textField = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
//    textField.placeholderString = "Enter text"
//    alert.accessoryView = textField
//    
//    if let window = self.view?.window {
//        alert.beginSheetModal(for: window) { response in
//            if response == NSApplication.ModalResponse.alertFirstButtonReturn {
//                completion(textField.stringValue)
//            } else {
//                completion(nil)
//            }
//        }
//    }
//}
