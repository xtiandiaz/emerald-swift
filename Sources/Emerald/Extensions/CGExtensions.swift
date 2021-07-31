//
//  CGExtensions.swift
//  Emerald
//
//  Created by Cristian Díaz on 29.7.2021.
//

import CoreGraphics

public extension CGPoint {
    
    static var up: CGPoint {
        CGPoint(x: 0, y: 1)
    }
    
    static var right: CGPoint {
        CGPoint(x: 1, y: 0)
    }
    
    static var down: CGPoint {
        CGPoint(x: 0, y: -1)
    }
    
    static var left: CGPoint {
        CGPoint(x: -1, y: 0)
    }
    
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func * (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
    }
}

public extension CGSize {
    
    static func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
        CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
    }
}
