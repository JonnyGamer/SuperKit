//
//  Key.swift
//
//
//  Created by Jonathan Pappas on 8/14/23.
//

import Foundation

//// use strings instead →
//@objc public enum Key: UInt16 {
//    case none = 0b1111111111111111
//    case accent = 50
//    case one = 18
//    case two = 19
//    case three = 20
//    case four = 21
//    case five = 23
//    case six = 22
//    case seven = 26
//    case eight = 28
//    case nine = 25
//    case zero = 29
//    case minus = 27
//    case equal = 24
//    case delete = 51
//    case tab = 48
//    case q = 12
//    case w = 13
//    case e = 14
//    case r = 15
//    case t = 17
//    case y = 16
//    case u =  32
//    case i = 34
//    case o = 31
//    case p = 35
//    case leftSquareBracket = 33
//    case rightSquareBracket = 30
//    case forwardslash = 42
//    case a = 0
//    case s = 1
//    case d = 2
//    case f = 3
//    case g = 5
//    case h = 4
//    case j = 38
//    case k = 40
//    case l = 37
//    case semicolon = 41
//    case semiquote = 39
//    case `return` = 36
//    case z = 6
//    case x = 7
//    case c = 8
//    case v = 9
//    case b = 11
//    case n = 45
//    case m =  46
//    case comma = 43
//    case period = 47
//    case backslash = 44
//    case space = 49
//    case leftArrow = 123
//    case upArrow = 126
//    case downArrow = 125
//    case rightArrow = 124
//    case unknown = 1000
//}

import SpriteKit
extension NSEvent.ModifierFlags {
    func specialKeys() -> [Keyboard.Special] {
        return Keyboard.Special.find(rawValue)
    }
}

public typealias Key = Keyboard.Normal

public enum Keyboard {
    
    @objc public enum Normal: UInt16 {
        case accent=50, one=18, two=19, three=20, four=21, five=23, six=22, seven=26, eight=28, nine=25, zero=29, minus=27, equal=24//,delete=51,tab=48
        case q=12, w=13, e=14, r=15, t=17, y=16, u=32, i=34, o=31, p=35, openSquare=33, closeSquare=30, backslash=42
        case a=0, s=1, d=2, f=3, g=5, h=4, j=38, k=40, l=37, semicolon=41, semiquote=39//, enter=36
        case z=6, x=7, c=8, v=9, b=11, n=45, m=46, comma=43, period=47, forwardSlash=44
        case space=49
        case unknown=1000
        
        case delete = 51
        case leftArrow = 123
        case upArrow = 126
        case downArrow = 125
        case rightArrow = 124
        
        static var normal: [Self:String] = [.accent:"`",.one:"1",.two:"2",.three:"3",.four:"4",.five:"5",.six:"6",.seven:"7",.eight:"8",.nine:"9",.zero:"0",.minus:"-",.equal:"=",.q:"q",.w:"w",.e:"e",.r:"r",.t:"t",.y:"y",.u:"u",.i:"i",.o:"o",.p:"p",.openSquare:"[",.closeSquare:"]",.backslash:"\\",.a:"a",.s:"s",.d:"d",.f:"f",.g:"g",.h:"h",.j:"j",.k:"k",.l:"l",.semicolon:";",.semiquote:"'",.z:"z",.x:"x",.c:"c",.v:"v",.b:"b",.n:"n",.m:"m",.comma:",",period:".",.forwardSlash:"/",.space:" "]
        static var shift: [Self:String] = [.accent:"~",.one:"!",.two:"@",.three:"#",.four:"$",.five:"%",.six:"^",.seven:"&",.eight:"*",.nine:"(",.zero:")",.minus:"_",.equal:"+",.q:"Q",.w:"W",.e:"E",.r:"R",.t:"T",.y:"Y",.u:"U",.i:"I",.o:"O",.p:"P",.openSquare:"{",.closeSquare:"}",.backslash:"|",.a:"A",.s:"S",.d:"D",.f:"F",.g:"G",.h:"H",.j:"J",.k:"K",.l:"L",.semicolon:":",.semiquote:"\"",.z:"Z",.x:"X",.c:"C",.v:"V",.b:"B",.n:"N",.m:"M",.comma:"<",period:">",.forwardSlash:"?",.space:" "]
    }
    
    // Command V should do a paste action
    public enum Other: UInt16 {
        case delete=51,enter=36,tab=48//,space=49
        case up=126, down=125, left=123, right=124
    }
    public enum Special: CaseIterable {
        case shift
        case option
        case command
        case capsLock
        
        static func find(_ given: UInt) -> [Self] {
            var found: [Self] = []
            if given & 1048840 == 1048840 || given & 1048848 == 1048848 {
                found.append(.command)
            }
            if given & 524576 == 524576 || given & 524608 == 524608 {
                found.append(.option)
            }
            if given & 131330 == 131330 || given & 131332 == 131332 {
                found.append(.shift)
            }
            if given & 131330 == 131330 || given & 131332 == 131332 {
                found.append(.shift)
            }
            if given & 65792 == 65792 {
                found.append(.capsLock)
            }
            return found
        }
    }
    
}
