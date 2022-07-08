//
//  CollectionSpace.swift
//  Emerald
//
//  Created by Cristian Diaz on 6.7.2022.
//

import Beryllium
import Foundation
import SwiftUI

public protocol CollectionSpace: Space {
    
    associatedtype Collection: TokenCollection
    
    var collection: Collection { get }
}

extension CollectionSpace {
    
    public var tokenCapacity: Int {
        .max
    }
    
    public var tokenCount: Int {
        collection.count
    }
    
    public func canPlace(token: Collection.Element) -> Bool {
        tokenCount < tokenCapacity
    }
}

open class StackSpace<T: Token>: CollectionSpace {
    
    @Published public private(set) var collection = Stack<T>()
    
    open func place(token: T) {
        if canPlace(token: token) {
            collection.push(token)
        }
    }
    
    // MARK: - Public
    
    public init() {
    }
    
    public func peek(at localPosition: CGPoint) -> T? {
        collection.peek()
    }

    public func take(at localPosition: CGPoint) -> T? {
        collection.pop()
    }
    
    public func canInteract(with token: T) -> Bool {
        collection.peek()?.canInteract(with: token) == true
    }
    
    public func interact(with token: T) {
        collection.peek()?.interact(with: token)
    }
}

open class QueueSpace<T: Token>: CollectionSpace {
    
    @Published public private(set) var collection = Queue<T>()
    
    open func place(token: T) {
        if canPlace(token: token) {
            collection.add(token)
        }
    }
    
    // MARK: - Public
    
    public func peek(at localPosition: CGPoint) -> T? {
        collection.peek()
    }
    
    public func take(at localPosition: CGPoint) -> T? {
        collection.poll()
    }
    
    public func canInteract(with token: T) -> Bool {
        collection.peek()?.canInteract(with: token) == true
    }
    
    public func interact(with token: T) {
        collection.peek()?.interact(with: token)
    }
}
