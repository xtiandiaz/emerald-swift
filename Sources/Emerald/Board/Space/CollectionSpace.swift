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
        collection.peek(at: localPosition)
    }

    public func take(at localPosition: CGPoint) -> T? {
        collection.take(at: localPosition)
    }
}

    
//    open var tokenCapacity: Int {
//        .max
//    }
//
//    open func canPlace(token: T.Element) -> Bool {
//        tokenCount < tokenCapacity
//    }
//
//    // MARK: - Public
//
//    public var tokenCount: Int {
//        collection.count
//    }
//
//    public func peek(at localPosition: CGPoint) -> T.Element? {
//        collection.peek(at: localPosition)
//    }
//
//    public func take(at localPosition: CGPoint) -> T.Element? {
//        collection.take(at: localPosition)
//    }
//
//    public func canInteract(with token: T.Element) -> Bool {
//        collection.canInteract(with: token)
//    }
//
//    public func interact(with token: T.Element) {
//        collection.interact(with: token)
//    }
//
//    public func place(token: T.Element) {
//
//    }
//
//    public func enumerate() -> EnumeratedSequence<T> {
//        collection.enumerated()
//    }
//
//    // MARK: - Internal
//
//    private(set) var collection: T
//
//    init(collection: T) {
//        self.collection = collection
//    }
