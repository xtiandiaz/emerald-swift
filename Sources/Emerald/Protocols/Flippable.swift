//
//  Flippable.swift
//  Emerald
//
//  Created by Cristian Diaz on 23.6.2022.
//

import Beryllium
import Foundation

public enum FlipSide {
    
    case front,
         back
    
    @discardableResult
    public mutating func toggle() -> FlipSide {
        self = self == .front ? .back : .front
        return self
    }
}

public protocol Flippable {
    
    var side: FlipSide { get }
    
    func flipOver(side: FlipSide, toward direction: Direction, animated: Bool)
    func flipOver(side: FlipSide)
    
    func whirl(times: Int, toward direction: Direction)
}
