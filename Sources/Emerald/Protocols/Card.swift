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
    func canInteract(with other: Self) -> Bool
}

extension Card {
    
    public var type: TokenType {
        .card
    }
}
