//
//  Token.swift
//  Emerald
//
//  Created by Cristian Diaz on 25.6.2022.
//

import Foundation

public protocol Token: AnyToken {
    
    func canInteractWith(other: Self) -> Bool
    func interactWith(other: Self)
    
    func canSwapWith(other: Self) -> Bool
}

public protocol Card: Token, Flippable {
    
    associatedtype CardType
    
    var type: CardType { get }
}
