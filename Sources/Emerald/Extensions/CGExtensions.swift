//
//  CGExtensions.swift
//  Emerald
//
//  Created by Cristian Díaz on 29.7.2021.
//

import Beryllium
import CoreGraphics
import simd.vector_types

public extension CGFloat {
    
    /// 4pt
    static let xs: CGFloat = 4
    /// 8pt
    static let s: CGFloat = 8
    /// 16pt
    static let ms: CGFloat = 16
    /// 24pt
    static let m: CGFloat = 24
    /// 28pt
    static let ml: CGFloat = 28
    /// 32pt
    static let l: CGFloat = 32
    /// 48pt
    static let xl: CGFloat = 48
    /// 64pt
    static let xxl: CGFloat = 64
    
    static func * (lhs: Int, rhs: CGFloat) -> CGFloat {
        CGFloat(lhs) * rhs
    }
    
    static func * (lhs: CGFloat, rhs: Int) -> CGFloat {
        lhs * CGFloat(rhs)
    }
}

public typealias Vector = CGPoint

public func abs(_ point: CGPoint) -> CGPoint {
    CGPoint(x: abs(point.x), y: abs(point.y))
}

extension CGPoint {
    
    public func vectorNormalized(toward target: CGPoint) -> Vector {
        let vector = vector(toward: target)
        let max = max(abs(vector.x), abs(vector.y))
        
        return max == 0 ? .zero : Vector(x: vector.x / max, y: vector.y / max)
    }
    
    public func vector(toward target: CGPoint) -> Vector {
        Vector(x: target.x - x, y: target.y - y)
    }
    
    public func direction(toward target: CGPoint) -> Direction? {
        let vector  = Vector(x: target.x - x, y: target.y - y)
        
        guard vector != .zero else {
            return nil
        }
        
        let absVector = abs(vector)
        
        return absVector.x > absVector.y
            ? vector.x > 0 ? .right : .left
            : vector.y > 0 ? .up : .down
    }
}
