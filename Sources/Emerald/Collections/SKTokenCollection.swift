//
//  SKTokenCollection.swift
//  Emerald
//
//  Created by Cristian Diaz on 16.5.2022.
//

import Beryllium
import Foundation
import SpriteKit

public protocol SKTokenCollection: Collection where Element: SKToken {
    
    mutating func insert(_ item: Element, at index: Int)
    
    mutating func remove(at location: CGPoint) -> Element?
    mutating func remove(at index: Index) -> Element
    mutating func removeAll(where shouldBeRemoved: (Element) -> Bool)
}

extension Stack: SKTokenCollection where Element: SKToken {
    
    public mutating func remove(at location: CGPoint) -> Element? {
        pop()
    }
}

extension Queue: SKTokenCollection where Element: SKToken {
    
    public mutating func remove(at location: CGPoint) -> Element? {
        poll()
    }
}
