//
//  CollectionExtensions.swift
//  Emerald
//
//  Created by Cristian Diaz on 12.10.2022.
//

import Foundation

extension Collection where Element == any Space {
    
    public func contains(_ element: Element) -> Bool {
        contains { $0.id == element.id }
    }
}

extension Collection where Element == any Board {
    
    public func contains(_ element: Element) -> Bool {
        contains { $0.id == element.id }
    }
}
