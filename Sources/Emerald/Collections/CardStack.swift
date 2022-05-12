//
//  CardStack.swift
//  Emerald
//
//  Created by Cristian Diaz on 12.5.2022.
//

import Foundation

public class CardStack: CardCollection {
    
    public private(set) var capacity: Int?
    public private(set) var isDirty = false
    
    public init(capacity: Int? = nil) {
        self.capacity = capacity
    }
    
    public func peek() -> Card? {
        cards.last
    }
    
    public func push(_ card: Card) {
        cards.append(card)
    }
    
    public func pop() -> Card? {
        cards.removeLast()
    }
    
    public func remove(_ card: Card) -> Card? {
        if let index = firstIndex(of: card) {
            return remove(at: index)
        }
        
        return nil
    }
    
    public func remove(at index: Int) -> Card? {
        cards.remove(at: index)
    }
    
    public func firstIndex(of card: Card) -> Int? {
        cards.firstIndex { card == $0 }
    }
    
    // MARK: - Private
    
    private var cards = [Card]()
}

extension CardStack: Collection {
    
    public typealias Index = Array<Card>.Index
    public typealias Element = Array<Card>.Element
    
    public var startIndex: Index {
        cards.reversed().startIndex
    }
    
    public var endIndex: Index {
        cards.reversed().endIndex
    }
    
    public subscript(index: Index) -> Element {
        get { cards.reversed()[index] }
    }
    
    public func index(after i: Index) -> Index {
        cards.reversed().index(after: i)
    }
}
