//
//  Deck.swift
//  Emerald
//
//  Created by Cristian Diaz on 16.5.2022.
//

import Foundation

public struct DeckCard<T> {
    
    public let type: T
    public let value: Int
    
    public init(type: T, value: Int) {
        self.type = type
        self.value = value
    }
}

public protocol Deck {
    
    associatedtype CardType: Card
    
    func take(count: Int) -> [CardType]
}
