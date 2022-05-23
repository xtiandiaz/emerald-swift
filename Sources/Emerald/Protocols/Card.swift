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
}

extension Card {
    
    public var type: TokenType {
        .card
    }
}
