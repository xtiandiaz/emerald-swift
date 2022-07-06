//
//  SKCollectionSpace.swift
//  Emerald
//
//  Created by Cristian Diaz on 14.5.2022.
//

import Beryllium
import Foundation
import SpriteKit

open class SKCollectionSpace<T: TokenCollection>: SKSpace<T.Element> {
    
    open override var tokenCapacity: Int {
        .max
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
        
    public let layout: SKCollectionSpaceLayout
    
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
    
    public override func setTokensLocked(_ locked: Bool, where predicate: (T.Element) -> Bool) {
        collection.filter(predicate).forEach {
            $0.isLocked = true
        }
    }
    
    // MARK: - Internal
    
    var collection: T
    
    init(collection: T, layout: SKCollectionSpaceLayout = .default) {
        self.collection = collection
        self.layout = layout
        
        super.init()
    }
}

// MARK: - Stack

open class StackSpace<T: SKToken>: SKCollectionSpace<Stack<T>> {
    
    open override func place(token: T) {
        place(token: token) {
            collection.push($0)
        }
    }
    
    // MARK: - Public
    
    public init(layout: SKCollectionSpaceLayout = .default) {
        super.init(collection: Stack<T>(), layout: layout)
    }
    
    public override func peek(at localPosition: CGPoint) -> T? {
        if let peek = peek(), peek.contains(localPosition) {
            return peek
        }
        
        return nil
    }
    
    public override func take(at localPosition: CGPoint) -> T? {
        peek(at: localPosition) != nil ? pop() : nil
    }
    
    public override func canInteractWith(token: T) -> Bool {
        peek()?.canInteractWith(other: token) == true
    }
    
    public override func interactWith(token: T) {
        peek()?.interactWith(other: token)
    }
    
    public override func canSwapWith(token: T) -> Bool {
        peek()?.canSwapWith(other: token) == true
    }
    
    // MARK: - Internal
    
    override func restore(token: T) {
        place(token: token) {
            collection.insert($0, at: collection.count)
        }
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

open class QueueSpace<T: SKToken>: SKCollectionSpace<Queue<T>> {
    
    open override func place(token: T) {
        place(token: token) {
            collection.add($0)
        }
    }
    
    // MARK: - Public
    
    public init(layout: SKCollectionSpaceLayout = .default) {
        super.init(collection: Queue<T>(), layout: layout)
    }
    
    public override func peek(at localPosition: CGPoint) -> T? {
        if let peek = peek(), peek.contains(localPosition) {
            return peek
        }
        
        return nil
    }
    
    public override func take(at localPosition: CGPoint) -> T? {
        peek(at: localPosition) != nil ? poll() : nil
    }
    
    public override func canInteractWith(token: T) -> Bool {
        peek()?.canInteractWith(other: token) == true
    }
    
    public override func interactWith(token: T) {
        peek()?.interactWith(other: token)
    }
    
    public override func canSwapWith(token: T) -> Bool {
        peek()?.canSwapWith(other: token) == true
    }
    
    // MARK: - Internal
    
    override func restore(token: T) {
        place(token: token) {
            collection.insert($0, at: 0)
        }
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
