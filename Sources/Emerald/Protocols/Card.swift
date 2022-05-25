//
//  Card.swift
//  Emerald
//
//  Created by Cristian Diaz on 12.5.2022.
//

import Foundation
import SpriteKit

public enum CardSide {
    
    case front,
         back
}

public protocol Card: Token {
    
    var value: Int { get set }
    var side: CardSide { get }
    
    func canSwap(with other: Self) -> Bool
    
    func canMutate(with other: Self) -> Bool
    func mutate(with other: Self)
}

extension Card {
    
    public var type: TokenType {
        .card
    }
    
    public func canSwap(with other: Token) -> Bool {
        if let card: Self = other.asCard() {
            return canSwap(with: card)
        }
        
        return false
    }
}
