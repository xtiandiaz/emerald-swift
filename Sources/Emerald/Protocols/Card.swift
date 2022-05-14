//
//  Card.swift
//  Emerald
//
//  Created by Cristian Diaz on 12.5.2022.
//

import Foundation

public protocol Card: Token {
    
    var value: Int { get set }
}

extension Card {
    
    public var type: TokenType {
        .card
    }
}
