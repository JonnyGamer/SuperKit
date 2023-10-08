//
//  CircleMaths.swift
//  PappasSpriteKitUITesting
//
//  Created by Jonathan Pappas on 9/2/23.
//

import Foundation

func pointOnCircle(angle: Double, radius: Double) -> CGPoint {
    let angleInRadians = (angle+90).toRadians()
    let x = radius * cos(angleInRadians)
    let y = radius * sin(angleInRadians)
    return .init(x: x, y: y)
}

func pointOnCircle(angle: Double, circle: Circle) -> CGPoint {
    
    let angleInRadians = (angle+90).toRadians()
    let x = circle.x + circle.radius * cos(angleInRadians)
    let y = circle.y + circle.radius * sin(angleInRadians)
    return .init(x: x, y: y)
    
}

func angleOfPointOnCircle(_ point: CGPoint) -> Double {
    let angleInRadians = atan2(point.y/* - centerY*/, point.x/* - centerX*/)
    let angleInDegrees = angleInRadians.toDegrees() - 90
    
    return (angleInDegrees + 360).truncatingRemainder(dividingBy: 360)
}
