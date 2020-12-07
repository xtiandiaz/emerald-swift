//
//  Location.swift
//  Emerald
//
//  Created by Cristian Díaz on 22.11.2020.
//

import Foundation

public struct Location: Equatable, Hashable {
    
    public static let zero = Location(x: 0, y: 0)
    
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
        default: break
        }
    }
    
    public func shifted(toward direction: Direction, by steps: Int = 1) -> Location {
        switch direction {
        case .up: return Location(x: self.x, y: self.y + steps)
        case .right: return Location(x: self.x + steps, y: self.y)
        case .down: return Location(x: self.x, y: self.y - steps)
        case .left: return Location(x: self.x - steps, y: self.y)
        default: return self
        }
    }
}
