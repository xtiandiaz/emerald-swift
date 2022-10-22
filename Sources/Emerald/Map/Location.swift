//
//  Location.swift
//  Emerald
//
//  Created by Cristian Diaz on 16.10.2022.
//

import Foundation

public struct Location: Equatable {
    
    public static let zero = Location(x: 0, y: 0, index: 0)
    
    public var x: Int
    public var y: Int
    public var index: Int
    
    // MARK: - Internal
    
    init(x: Int, y: Int, index: Int) {
        self.x = x
        self.y = y
        self.index = index
    }
}
