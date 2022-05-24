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
        false
    }
    
    open func arrange() {
        for (index, item) in collection.enumerated() {
            arrange(item: item, at: index, in: collection.count)
        }
    }
    
    open func arrange(item: T.Element, at index: Int, in count: Int) {
        fatalError("Not implemented")
    }
    
    @discardableResult
    open func place(card: T.Element) -> T.Element? {
        guard accepts(card: card) else {
            return card
        }
        
        card.move(toParent: self)
        
        collection.insert(card)
        arrange()
        
        return nil
    }
    
    open func setHighlighted(_ highlighted: Bool) {
        fatalError("Not implemented")
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
    
    @discardableResult
    open override func place(card: T) -> T? {
        if let peek = peek(), card.canSwap(with: peek) {
            let swap = pop()
            super.place(card: card)
            return swap
        }
        
        return super.place(card: card)
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
