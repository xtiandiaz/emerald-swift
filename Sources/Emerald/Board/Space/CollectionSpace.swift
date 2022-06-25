//
//  CollectionSpace.swift
//  Emerald
//
//  Created by Cristian Diaz on 14.5.2022.
//

import Beryllium
import Foundation
import SpriteKit

open class CollectionSpace<T: TokenCollection>: Space<T.Element> {
    
    open override var tokenCapacity: Int {
        .max
    }
    
    open override var isLocked: Bool {
        false
    }
    
    open override func canInteractWith(token: T.Element, at localPosition: CGPoint) -> Bool {
        peek(at: localPosition)?.canInteractWith(other: token) == true
    }
    
    open override func interactWith(token: T.Element, at localPosition: CGPoint) {
        peek(at: localPosition)?.interactWith(other: token)
    }
    
    open override func canSwapWith(token: T.Element, at localPosition: CGPoint) -> Bool {
        peek(at: localPosition)?.canSwapWith(other: token) == true
    }
    
    open override func canPlace(token: T.Element) -> Bool {
        tokenCount < tokenCapacity
    }
    
    open func arrange(item: T.Element, at index: Int, in count: Int) {
        item.zPosition = CGFloat(count - index - 1)
        
        item.runIfValid(
            .move(
                to: .up * CGFloat(index) * layout.offset.asPoint(),
                duration: 0.1,
                timingMode: .easeOut
            ),
            withKey: "arrangement"
        )
    }
    
    // MARK: - Public
        
    public let layout: CollectionSpaceLayout
    
    public override var tokenCount: Int {
        collection.count
    }
    
    public override var isEmpty: Bool {
        collection.isEmpty
    }
    
    public override func arrange() {
        for (index, item) in collection.enumerated() {
            arrange(item: item, at: index, in: collection.count)
        }
    }
    
    public override func purge() -> [AnyToken] {
        let allInvalidated = collection.filter { $0.isInvalidated }
        collection.removeAll { $0.isInvalidated }
        
        arrange()
        
        return allInvalidated
    }
    
    // MARK: - Internal
    
    var collection: T
    
    init(collection: T, layout: CollectionSpaceLayout = .default) {
        self.collection = collection
        self.layout = layout
        
        super.init()
    }
}

extension CollectionSpace {
    
    public func remove(_ item: T.Element) -> T.Element? {
        if let index = collection.firstIndex(of: item) {
            return collection.remove(at: index)
        }
        
        return nil
    }
}

// MARK: - Stack

open class StackSpace<T: Token>: CollectionSpace<Stack<T>> {
    
    open override var isLocked: Bool {
        peek()?.isLocked == true
    }
    
    open override func place(token: T) {
        place(token: token) { [unowned self] in
            collection.push($0)
        }
    }
    
    // MARK: - Public
    
    public init(layout: CollectionSpaceLayout = .default) {
        super.init(collection: Stack<T>(), layout: layout)
    }
    
    public override func peek(at localPosition: CGPoint) -> T? {
        peek()
    }
    
    public override func take(at localPosition: CGPoint) -> T? {
        pop()
    }
}

extension StackSpace {
    
    public func peek() -> T? {
        collection.peek()
    }
    
    public func pop() -> T? {
        collection.pop()
    }
}

// MARK: - Queue

open class QueueSpace<T: Token>: CollectionSpace<Queue<T>> {
    
    open override var isLocked: Bool {
        peek()?.isLocked == true
    }
    
    open override func place(token: T) {
        place(token: token) { [unowned self] in
            collection.add($0)
        }
    }
    
    // MARK: - Public
    
    public init(layout: CollectionSpaceLayout = .default) {
        super.init(collection: Queue<T>(), layout: layout)
    }
    
    public override func peek(at localPosition: CGPoint) -> T? {
        peek()
    }
    
    public override func take(at localPosition: CGPoint) -> T? {
        poll()
    }
}

extension QueueSpace {
    
    public func peek() -> T? {
        collection.peek()
    }
    
    public func poll() -> T? {
        collection.poll()
    }
}
