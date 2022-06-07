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
    
    open var tokenCapacity: Int {
        .max
    }
    
    open var isLocked: Bool {
        false
    }
    
    open var isDirty = false
    
    open func accepts(token: T.Element) -> Bool {
        false
    }
    
    open func shouldForward(token: T.Element) -> Bool {
        false
    }
    
    open func place(token: T.Element) {
        place(token: token) {
            collection.insert($0)
        }
    }
    
    open func arrange() {
        guard isDirty else {
            return
        }
        
        for (index, item) in collection.enumerated() {
            arrange(item: item, at: index, in: collection.count)
        }
        
        isDirty = false
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
    
    open func setHighlighted(_ highlighted: Bool) {
    }
    
    // MARK: - Public
    
    public let layout: CollectionSpaceLayout
    
    public var tokenCount: Int {
        collection.count
    }
    
    public var isEmpty: Bool {
        collection.isEmpty
    }

    public func pickToken(at location: CGPoint) -> T.Element? {
        defer {
            isDirty = true
        }
        
        if let token = collection.remove(at: location), !token.isLocked {
            return token
        }
        
        return nil
    }
    
    public func canSwap(with token: T.Element) -> Bool {
        false
    }
    
    public func swap(with token: T.Element) -> T.Element? {
        nil
    }
    
    public func canMutate(with token: T.Element) -> Bool {
        false
    }
    
    public func mutate(with token: T.Element) {
    }
    
    public func canPlace(token: T.Element) -> Bool {
        collection.count < tokenCapacity && accepts(token: token)
    }
    
    public func purge() -> [AnyToken] {
        let allInvalidated = collection.filter { $0.isInvalidated }
        collection.removeAll { $0.isInvalidated }
        
        isDirty = true
        
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

open class StackSpace<T: Token>: CollectionSpace<Stack<T>> {
    
    public init(layout: CollectionSpaceLayout = .default) {
        super.init(collection: Stack<T>(), layout: layout)
    }
    
    public override func canSwap(with token: T) -> Bool {
        peek()?.canSwap(with: token) == true
    }
    
    public override func swap(with token: T) -> T? {
        let swap = pop()
        place(token: token)
        return swap
    }
    
    public override func canMutate(with token: T) -> Bool {
        peek()?.canMutate(with: token) == true
    }
    
    public override func mutate(with token: T) {
        peek()?.mutate(with: token)
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

open class QueueSpace<T: Token>: CollectionSpace<Queue<T>> {
    
    public init(layout: CollectionSpaceLayout = .default) {
        super.init(collection: Queue<T>(), layout: layout)
    }
    
    public override func canSwap(with token: T) -> Bool {
        peek()?.canSwap(with: token) == true
    }
    
    public override func swap(with token: T) -> T? {
        let swap = poll()
        place(token: token)
        return swap
    }
    
    public override func canMutate(with token: T) -> Bool {
        peek()?.canMutate(with: token) == true
    }
    
    public override func mutate(with token: T) {
        peek()?.mutate(with: token)
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
