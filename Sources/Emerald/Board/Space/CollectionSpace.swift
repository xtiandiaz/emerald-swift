//
//  CollectionSpace.swift
//  Emerald
//
//  Created by Cristian Diaz on 6.7.2022.
//

import Beryllium
import Foundation
import SwiftUI

open class CollectionSpace<Collection: TokenCollection>: Space {
    
    @Published public internal(set) var collection: Collection
    @Published public var isHighlighted = false
    
    open func place(token: Collection.Element) {
        fatalError("Not implemented")
    }
    
    // MARK: - Public
    
    public var tokenCapacity: Int {
        .max
    }
    
    public var tokenCount: Int {
        collection.count
    }
    
    public var isEmpty: Bool {
        collection.isEmpty
    }
    
    public func peek(at localPosition: CGPoint) -> Collection.Element? {
        fatalError("Not implemented")
    }
    
    public func take(at localPosition: CGPoint) -> Collection.Element? {
        fatalError("Not implemented")
    }
    
    public func canInteract(with token: Collection.Element) -> Bool {
        fatalError("Not implemented")
    }
    
    public func interact(with token: Collection.Element) {
        fatalError("Not implemented")
    }
    
    public func canPlace(token: Collection.Element) -> Bool {
        tokenCount < tokenCapacity
    }
    
    // MARK: - Internal
    
    init(collection: Collection) {
        self.collection = collection
    }
}

open class StackSpace<T: Token>: CollectionSpace<Stack<T>> {
    
    open override func place(token: T) {
        if canPlace(token: token) {
            collection.push(token)
        }
    }
    
    // MARK: - Public
    
    public init() {
        super.init(collection: Stack<T>())
    }
    
    public override func peek(at localPosition: CGPoint) -> T? {
        collection.peek()
    }

    public override func take(at localPosition: CGPoint) -> T? {
        collection.pop()
    }
    
    public override func canInteract(with token: T) -> Bool {
        collection.peek()?.canInteract(with: token) == true
    }
    
    public override func interact(with token: T) {
        collection.peek()?.interact(with: token)
    }
}

open class QueueSpace<T: Token>: CollectionSpace<Queue<T>> {
    
    open override func place(token: T) {
        if canPlace(token: token) {
            collection.add(token)
        }
    }
    
    // MARK: - Public
    
    public init() {
        super.init(collection: Queue<T>())
    }
    
    public override func peek(at localPosition: CGPoint) -> T? {
        collection.peek()
    }
    
    public override func take(at localPosition: CGPoint) -> T? {
        collection.poll()
    }
    
    public override func canInteract(with token: T) -> Bool {
        collection.peek()?.canInteract(with: token) == true
    }
    
    public override func interact(with token: T) {
        collection.peek()?.interact(with: token)
    }
}
