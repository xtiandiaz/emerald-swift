//
//  CGExtensions.swift
//  Emerald
//
//  Created by Cristian Díaz on 29.7.2021.
//

import CoreGraphics
import simd.vector_types

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

public typealias Vector = CGPoint

public extension CGPoint {
    
    init(xy: CGFloat) {
        self.init(x: xy, y: xy)
    }
    
    init(x: CGFloat) {
        self.init(x: x, y: 0)
    }
    
    init(x: Int) {
        self.init(x: x, y: 0)
    }
    
    init(y: CGFloat) {
        self.init(x: 0, y: y)
    }
    
    init(y: Int) {
        self.init(x: 0, y: y)
    }
    
    static var one: CGPoint {
        CGPoint(xy: 1)
    }
    
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
    
    static func * (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
    }
    
    static func * (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
    }
    
    func vector_float2() -> vector_float2 {
        simd.vector_float2(Float(x), Float(y))
    }
}

public extension CGSize {
    
    init(length: CGFloat) {
        self.init(width: length, height: length)
    }
    
    var center: CGPoint {
        CGPoint(x: width * 0.5, y: height * 0.5)
    }
    
    var aspectRatio: CGFloat {
        width / height
    }
    
    var inverseAspectRatio: CGFloat {
        height / width
    }
    
    static func + (lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }
    
    static func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
        CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
    }
}

public extension CGRect {
    
    var center: CGPoint {
        CGPoint(x: minX + width * 0.5, y: minY + height * 0.5)
    }
}
