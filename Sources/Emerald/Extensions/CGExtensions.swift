//
//  CGExtensions.swift
//  Emerald
//
//  Created by Cristian Díaz on 29.7.2021.
//

import CoreGraphics

public extension CGFloat {
    
    /// 2pt
    static let xxs: CGFloat = 2
    /// 4pt
    static let xs: CGFloat = 4
    /// 8pt
    static let s: CGFloat = 8
    /// 12pt
    static let ms: CGFloat = 12
    /// 16pt
    static let m: CGFloat = 16
    /// 20pt
    static let ml: CGFloat = 20
    /// 24pt
    static let l: CGFloat = 24
    /// 32pt
    static let xl: CGFloat = 32
    /// 48pt
    static let xxl: CGFloat = 48
    /// 64pt
    static let xxxl: CGFloat = 64
}
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
