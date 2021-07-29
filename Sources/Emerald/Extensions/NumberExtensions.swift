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

