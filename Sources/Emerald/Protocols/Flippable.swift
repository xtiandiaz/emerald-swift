//
//  Flippable.swift
//  Emerald
//
//  Created by Cristian Diaz on 23.6.2022.
//

import Beryllium
import Foundation

public enum FlatTokenSide {
    
    case front,
         back
    
    @discardableResult
    public mutating func toggle() -> FlatTokenSide {
        self = self == .front ? .back : .front
        return self
    }
}

public protocol Flippable {
    
    var side: FlatTokenSide { get }
    
    func flipOver(side: FlatTokenSide, toward direction: Direction, animated: Bool)
    func flipOver(side: FlatTokenSide)
    
    func whirl(times: Int, toward direction: Direction)
}
