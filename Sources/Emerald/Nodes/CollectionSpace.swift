//
//  CollectionSpace.swift
//  Emerald
//
//  Created by Cristian Diaz on 14.5.2022.
//

import Beryllium
import Foundation
import SpriteKit

open class CollectionSpace<T: TokenCollection>: Node, Space {
    
    open var capacity: Int {
        .max
    }
    
    public var isEmpty: Bool {
        collection.isEmpty
    }

    open func pickToken(at location: CGPoint) -> T.Element? {
        if let token = collection.remove(at: location), !token.isLocked {
            return token
        }
        
        return nil
    }
    
    open func accepts(token: T.Element) -> Bool {
        false
    }
    
    open func canPlace(token: T.Element) -> Bool {
        collection.count < capacity && accepts(token: token)
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
    open func place(token: T.Element) -> T.Element? {
        guard canPlace(token: token) else {
            return token
        }
        
        token.move(toParent: self)
        
        collection.insert(token)
        arrange()
        
        return nil
    }
    
    open func setHighlighted(_ highlighted: Bool) {
    }
    
    public func remove(_ item: T.Element) -> T.Element? {
        if let index = collection.firstIndex(of: item) {
            return collection.remove(at: index)
        }
        
        return nil
    }
    
    public func purge() -> [Token] {
        let allInvalidated = collection.filter { $0.isInvalidated }
        collection.removeAll { $0.isInvalidated }
        return allInvalidated
    }
    
    // MARK: - Internal
    
    var collection: T
    
    init(collection: T) {
        self.collection = collection
        
        super.init()
    }
}

open class StackSpace<T: Token & Swappable & Mutable>: CollectionSpace<Stack<T>> {
    
    public let layout: StackSpaceLayout
    
    public init(layout: StackSpaceLayout = .default) {
        self.layout = layout
        
        super.init(collection: Stack<T>())
    }
    
    public func peek() -> T? {
        collection.peek()
    }
    
    public func pop() -> T? {
        collection.pop()
    }
    
    open override func canPlace(token: T) -> Bool {
        if let peek = peek() {
            return peek.canSwap(with: token) ||
                peek.canMutate(with: token) ||
                super.canPlace(token: token)
        }
        
        return super.canPlace(token: token)
    }
    
    @discardableResult
    open override func place(token: T) -> T? {
        if let peek = peek() {
            if peek.canSwap(with: token) {
                let swap = pop()
                super.place(token: token)
                return swap
            } else if peek.canMutate(with: token) {
                peek.mutate(with: token)
                return token
            }
        }
        
        return super.place(token: token)
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
