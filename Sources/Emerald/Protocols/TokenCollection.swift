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
    
    mutating func remove(at index: Index) -> Element
    mutating func remove(at location: CGPoint) -> Element?
    mutating func removeAll(where shouldBeRemoved: (Element) -> Bool)
}

extension Stack: TokenCollection where Element: Token {
    
    public mutating func insert(_ item: Element) {
        push(item)
    }
    
    public mutating func remove(at location: CGPoint) -> Element? {
        pop()
    }
}

extension Queue: TokenCollection where Element: Token {
    
    public mutating func insert(_ item: Element) {
        add(item)
    }
    
    public mutating func remove(at location: CGPoint) -> Element? {
        poll()
    }
}
