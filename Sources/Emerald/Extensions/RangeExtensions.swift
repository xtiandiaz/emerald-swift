//
//  RangeExtensions.swift
//  Emerald
//
//  Created by Cristian Díaz on 7.12.2020.
//

import Foundation

extension ClosedRange {
    
    public func clamp(value : Bound) -> Bound {
        lowerBound > value ? lowerBound : upperBound < value ? upperBound : value
    }
}
