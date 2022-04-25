//
//  StringExtensions.swift
//  Emerald
//
//  Created by Cristian Diaz on 25.4.2022.
//

import Foundation

public extension DefaultStringInterpolation {
    
    mutating func appendInterpolation<T>(_ optional: T?) {
        if let value = optional {
            appendLiteral(String(describing: value))
        } else {
            appendLiteral("nil")
        }
    }
}
