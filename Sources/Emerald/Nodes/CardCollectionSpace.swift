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

    open func pickCard(at location: CGPoint) -> T.Element? {
        collection.remove(at: location)
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
        for (index, item) in collection.enumerated() {
            arrange(item: item, at: index, in: collection.count)
        }
    }
    
    open func arrange(item: T.Element, at index: Int, in count: Int) {
        fatalError("Not implemented")
    }
    
    open func showOptions() {
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
    
    open var layout: CardStackLayout {
        .default
    }
    
    public init() {
        super.init(collection: Stack<T>())
    }
    
    public func peek() -> T? {
        collection.peek()
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
