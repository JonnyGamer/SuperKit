//
//  Goodbye.swift
//  PappasSpriteKitUITesting
//
//  Created by Jonathan Pappas on 8/31/23.
//

import Foundation

func sayGoodbye<T: AnyObject>(_ this: T) {
    let address = unsafeBitCast(this, to: Int.self)
    TotalObjects.remove(address)
    //print("Good bye, \(this)")
    //print("Removing:", TotalObjects.count)
}
var TotalObjects: Set<Int> = []
func sayHello<T: AnyObject>(_ this: T) {
    let address = unsafeBitCast(this, to: Int.self)
    TotalObjects.insert(address)
}
