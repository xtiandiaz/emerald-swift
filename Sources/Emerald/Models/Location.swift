//
//  GridLocation.swift
//  Emerald
//
//  Created by Cristian Díaz on 22.11.2020.
//

import Foundation

public struct GridLocation: Equatable, Hashable {
    
    public static let zero = GridLocation(x: 0, y: 0)
    
    public var x: Int
    public var y: Int
    
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    public mutating func shift(toward direction: Direction, by steps: Int = 1) {
        switch direction {
        case .up: self.y += steps
        case .right: self.x += steps
        case .down: self.y -= steps
        case .left: self.x -= steps
        }
    }
    
    public func shifted(toward direction: Direction, by steps: Int = 1) -> GridLocation {
        switch direction {
        case .up: return GridLocation(x: self.x, y: self.y + steps)
        case .right: return GridLocation(x: self.x + steps, y: self.y)
        case .down: return GridLocation(x: self.x, y: self.y - steps)
        case .left: return GridLocation(x: self.x - steps, y: self.y)
        }
    }
}
