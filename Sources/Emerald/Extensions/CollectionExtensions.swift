//
//  CollectionExtensions.swift
//  Emerald
//
//  Created by Cristian Díaz on 9.8.2021.
//

import Foundation

public extension Array {
    
    func isValid(index: Int) -> Bool {
        index >= 0 && index < count
    }
}
