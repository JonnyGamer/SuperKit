// The Swift Programming Language
// https://docs.swift.org/swift-book

public struct SuperKit {
    
    public static func RemoveBelow(_ name: String) {
        for i in root.children {
            if i.name == "Coal"{
                if i.y < -100 {
                    i.remove()
                }
            }
        }
    }
    
    public static func CountIf(_ name: String, isInside: String, height: Double) -> Int {
        let zone = root.children.first { $0.name == isInside }!
        var count = 0
        
        for i in root.children {
            if i.name == name {
                if i.y < -100 {
                    i.remove()
                } else if i.name == "Present" && i.x > zone.minX && i.x < zone.maxX && i.maxY < height {
                    count += 1
                }
            }
        }
        return count
    }
}
