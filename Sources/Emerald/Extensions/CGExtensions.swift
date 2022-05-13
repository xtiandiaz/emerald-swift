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

public func abs(_ point: CGPoint) -> CGPoint {
    CGPoint(x: abs(point.x), y: abs(point.y))
}

public extension CGPoint {
    
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
    
    func distanceSquared(to: CGPoint) -> CGFloat {
        (to.x - x) * (to.x - x) + (to.y - y) * (to.y - y)
    }
    
    func distance(to: CGPoint) -> CGFloat {
        sqrt(distanceSquared(to: to))
    }
    
    func offset(to: CGPoint) -> CGSize {
        CGSize(width: to.x - x, height: to.y - y)
    }
    
    func vector(toward target: CGPoint) -> Vector {
        Vector(x: target.x - x, y: target.y - y)
    }
    
    func vectorNormalized(toward target: CGPoint) -> Vector {
        let vector = vector(toward: target)
        let max = max(abs(vector.x), abs(vector.y))
        
        return max == 0 ? .zero : Vector(x: vector.x / max, y: vector.y / max)
    }
    
    func direction(toward target: CGPoint) -> Direction? {
        let vector  = Vector(x: target.x - x, y: target.y - y)
        
        guard vector != .zero else {
            return nil
        }
        
        let absVector = abs(vector)
        
        return absVector.x > absVector.y
            ? vector.x > 0 ? .right : .left
            : vector.y > 0 ? .up : .down
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
    
    func asOffset() -> CGSize {
        CGSize(width: x, height: y)
    }
    
    func vector_float2() -> vector_float2 {
        simd.vector_float2(Float(x), Float(y))
    }
}

public extension CGSize {
    
    static var one: CGSize {
        CGSize(length: 1)
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
    
    var magnitude: CGFloat {
        asPoint().distance(to: .zero)
    }
    
    var magnitudeSquared: CGFloat {
        asPoint().distanceSquared(to: .zero)
    }
    
    init(length: CGFloat) {
        self.init(width: length, height: length)
    }
    
    init(width: CGFloat) {
        self.init(width: width, height: 1)
    }
    
    init(height: CGFloat) {
        self.init(width: 1, height: height)
    }
    
    static func + (lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }
    
    static func - (lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }
    
    static func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
        CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
    }
    
    static func / (lhs: CGSize, rhs: CGFloat) -> CGSize {
        CGSize(width: lhs.width / rhs, height: lhs.height / rhs)
    }
    
    func asPoint() -> CGPoint {
        CGPoint(x: width, y: height)
    }
}

public extension CGRect {
    
    var center: CGPoint {
        CGPoint(x: minX + width * 0.5, y: minY + height * 0.5)
    }
}
