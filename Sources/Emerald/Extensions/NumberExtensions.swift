//
//  NumberExtensions.swift
//  Emerald
//
//  Created by Cristian Díaz on 19.12.2020.
//

import Foundation

public extension Int {
    
    func stepAround(_ a: Int, _ b: Int, by: Int = 1) -> Int {
        var next = self + by
        if next < a || next >= b {
            next = a
        }
        return next
    }
}

public extension Double {
    
    static func * (lhs: Int, rhs: Double) -> Double {
        Double(lhs) * rhs
    }
    
    static func * (lhs: Double, rhs: Int) -> Double {
        lhs * Double(rhs)
    }
    
    static func / (lhs: Int, rhs: Double) -> Double {
        Double(lhs) / rhs
    }
}

public extension Float {
    
    static func * (lhs: Int, rhs: Float) -> Float {
        Float(lhs) * rhs
    }
    
    static func * (lhs: Float, rhs: Int) -> Float {
        lhs * Float(rhs)
    }
    
    static func / (lhs: Int, rhs: Float) -> Float {
        Float(lhs) / rhs
    }
}
