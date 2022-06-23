//
//  Card.swift
//  Emerald
//
//  Created by Cristian Diaz on 23.6.2022.
//

import Beryllium
import Foundation

public enum CardSide {
    
    case front,
         back
}

public protocol Card: AnyToken {
    
    var side: CardSide { get }
    
    func canInteractWith(other: Self) -> Bool
    func interactWith(other: Self)
    
    func flip(toSide side: CardSide, toward direction: Direction, animated: Bool)
}
