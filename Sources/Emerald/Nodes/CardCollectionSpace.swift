//
//  CardCollectionSpace.swift
//  Emerald
//
//  Created by Cristian Diaz on 14.5.2022.
//

import Beryllium
import Foundation
import SpriteKit

open class CardCollectionSpace<T: CardCollection>: Node, CardSpace {
    
    public var isLocked = false
    
    public var isEmpty: Bool {
        collection.isEmpty
    }

    open func pickCard(at location: CGPoint) -> T.Element? {
        collection.remove(at: location)
    }
    
    open func accepts(card: T.Element) -> Bool {
        true
    }
    
    open func move(forCard card: T.Element) -> TokenMove? {
        .place
    }
    
    open func arrange() {
        for (index, item) in collection.enumerated() {
            arrange(item: item, at: index, in: collection.count)
        }
    }
    
    open func arrange(item: T.Element, at index: Int, in count: Int) {
        fatalError("Not implemented")
    }
    
    open func setHighlighted(_ highlighted: Bool) {
    }
    
    public func place(card: T.Element) {
        card.move(toParent: self)
        
        collection.insert(card)
        arrange()
    }
    
    public func remove(_ item: T.Element) -> T.Element? {
        if let index = collection.firstIndex(of: item) {
            return collection.remove(at: index)
        }
        
        return nil
    }
    
    public func removeAll(where shouldBeRemoved: (T.Element) -> Bool) {
        collection.removeAll(where: shouldBeRemoved)
    }
    
    // MARK: - Internal
    
    var collection: T
    
    init(collection: T) {
        self.collection = collection
        
        super.init()
    }
}

open class CardStackSpace<T: Card>: CardCollectionSpace<Stack<T>> {
    
    public let layout: CardStackLayout
    
    public init(layout: CardStackLayout = .default) {
        self.layout = layout
        
        super.init(collection: Stack<T>())
    }
    
    public func peek() -> T? {
        collection.peek()
    }
    
    public func pop() -> T? {
        collection.pop()
    }
    
    open override func accepts(card: T) -> Bool {
        if let peek = peek() {
            return card.canSwap(with: peek) || card.canInteract(with: peek)
        }
        
        return super.accepts(card: card)
    }
    
    open override func move(forCard card: T) -> TokenMove? {
        if let peek = peek() {
            if card.canSwap(with: peek) {
                return .swap(with: pop()!)
            } else if card.canInteract(with: peek) {
                return .interact(with: pop()!)
            }
        }
        
        return super.move(forCard: card)
    }
    
    open override func arrange(item: T, at index: Int, in count: Int) {
        item.zPosition = CGFloat(count - index - 1)
        
        item.runIfValid(
            .move(
                to: .up * CGFloat(index) * layout.offset.asPoint(),
                duration: 0.1,
                timingMode: .easeOut
            ),
            withKey: "move"
        )
    }
}
