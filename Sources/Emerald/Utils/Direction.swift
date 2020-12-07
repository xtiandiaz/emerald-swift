//
//  Direction.swift
//  Emerald
//
//  Created by Cristian Díaz on 19.10.2020.
//

public struct Direction: OptionSet, Hashable {
    
    public static let up = Direction(rawValue: 1 << 0)
    public static let right = Direction(rawValue: 1 << 1)
    public static let down = Direction(rawValue: 1 << 2)
    public static let left = Direction(rawValue: 1 << 3)
    
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}
