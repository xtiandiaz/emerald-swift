//
//  CardCollectionSpace.swift
//  Emerald
//
//  Created by Cristian Diaz on 14.5.2022.
//

import Beryllium
import Foundation
import SpriteKit

public protocol CardCollection: Collection where Element: Card {
    
    mutating func insert(_ item: Element)
    mutating func remove(at location: CGPoint) -> Element?
}

extension Stack: CardCollection where Element: Card {
    
    public mutating func insert(_ item: Element) {
        push(item)
    }
    
    public mutating func remove(at location: CGPoint) -> Element? {
        pop()
    }
}

open class CardCollectionSpace<T: CardCollection>: Node, CardSpace {
    
    public var isLocked = false

    open func pickCard(at location: CGPoint) -> T.Element? {
        defer {
            arrange()
        }
        
        return collection.remove(at: location)
    }
    
    open func accepts(card: T.Element) -> Bool {
        true
    }
    
    @discardableResult
    open func place(card: T.Element) -> Bool {
        card.move(toParent: self)
        
        collection.insert(card)
        arrange()
        
        return true
    }
    
    open func arrange() {
        fatalError("Not implemented")
    }
    
    open func setHighlighted(_ highlighted: Bool) {
    }
    
    // MARK: - Internal
    
    var collection: T
    
    init(collection: T) {
        self.collection = collection
        
        super.init()
    }
}

open class CardStackSpace<T: Card>: CardCollectionSpace<Stack<T>> {
    
    public init() {
        super.init(collection: Stack<T>())
    }
    
    open override func arrange() {
        for card in collection {
            card.position = .zero
        }
    }
}
