//
//  Then.swift
//  NextGenerationEditingTool
//
//  Created by Jonathan Pappas on 4/11/23.
//

import Foundation

public protocol Then {}

extension Then where Self: AnyObject {
  @inlinable @discardableResult
  public func then(_ block: (Self) throws -> Void) rethrows -> Self {
    try block(self)
    return self
  }
}

extension Then where Self: NSObject {
    @inlinable
    public var copied: Self {
        return self.copy() as! Self
    }
}

extension NSObject: Then {
}



