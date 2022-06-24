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
}

public protocol Flippable {
    
    var side: FlipSide { get }
    
    func flipOver(side: FlipSide, toward direction: Direction, animated: Bool)
}
