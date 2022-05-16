//
//  TokenCollection.swift
//  Emerald
//
//  Created by Cristian Diaz on 16.5.2022.
//

import Beryllium
import Foundation
import SpriteKit

public protocol TokenCollection: Collection where Element: Token {
    
    mutating func insert(_ item: Element)
    mutating func remove(at location: CGPoint) -> Element?
}

public protocol CardCollection: TokenCollection where Element: Card {
}

extension Stack: TokenCollection where Element: Token {
    
    public mutating func insert(_ item: Element) {
        push(item)
    }
    
    public mutating func remove(at location: CGPoint) -> Element? {
        pop()
    }
}

extension Stack: CardCollection where Element: Card {
}
