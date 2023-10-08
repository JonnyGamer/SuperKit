//
//  TextRepresentation.swift
//  PappasSpriteKitUITesting
//
//  Created by Jonathan Pappas on 8/25/23.
//

import Foundation

class Text2D: NSObject {
    var text : [[String]] = [[]]
    override var description: String { text.map({ $0.joined() }).joined(separator: "\n") }
    
    override init() { super.init() }
    init(default text: String) { self.text = text.split(separator: "\n").map({ i in i.map({ j in String(j) }) }); super.init() }
    // [text.map({ String($0) })]; 
    
    func insert(_ n: String, at: (line: Int, character: Int)) {
        text[at.line].insert(n, at: at.character)
    }
    func insertCarriageReturn(at: (line: Int, character: Int)) {
        let dropped1: [String] = text[at.line].dropLast(numberOfCharacters(at: at) - at.character)
        let dropped2: [String] = Array(text[at.line].dropFirst(at.character))
        text[at.line] = dropped1
        text.insert(dropped2, at: at.line + 1)
    }
    func numberOfCharacters(at: (line: Int, character: Int)) -> Int {
        return text[at.line].count
    }
    func endOfText() -> (line: Int, character: Int) {
        return (text.count - 1, text[text.count - 1].count)
    }
    func character(at: (line: Int, character: Int)) -> Character {
        return Character(text[at.line][at.character-1])
    }
    func delete(at: (line: Int, character: Int)) {
        text[at.line].remove(at: at.character - 1)
    }
    func deleteCarriageReturn(at: (line: Int, character: Int)) -> (line: Int, character: Int) {
        var at = at
        let line = text[at.line]
        text.remove(at: at.line)
        at.line -= 1
        at.character = numberOfCharacters(at: at)
        text[at.line] += line
        return at
    }
}

//enum Undo {
//    case typeLetter(String)
//    case deleteLetter(String)
//    case enter
//    case deleteEnter
//
//    var undo: Self {
//        switch self {
//            case .enter : return .deleteEnter
//            case .deleteEnter : return .enter
//            case let .typeLetter(s): return .deleteLetter(s)
//            case let .deleteLetter(s): return .typeLetter(s)
//        }
//    }
//}
