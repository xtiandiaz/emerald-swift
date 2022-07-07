//
//  CollectionSpace.swift
//  Emerald
//
//  Created by Cristian Diaz on 6.7.2022.
//

import Foundation
import SwiftUI

public class CollectionSpace<T: TokenCollection>: Space, ObservableObject {
    
    open var tokenCapacity: Int {
        .max
    }
    
    open func canPlace(token: T.Element) -> Bool {
        tokenCount < tokenCapacity
    }
    
    // MARK: - Public
    
    public var tokenCount: Int {
        collection.count
    }
    
    public func peek(at localPosition: CGPoint) -> T.Element? {
        collection.peek(at: localPosition)
    }
    
    public func take(at localPosition: CGPoint) -> T.Element? {
        collection.take(at: localPosition)
    }
    
    public func canInteract(with token: T.Element) -> Bool {
        collection.canInteract(with: token)
    }
    
    public func interact(with token: T.Element) {
        collection.interact(with: token)
    }
    
    public func place(token: T.Element) {
        
    }
    
    // MARK: - Internal
    
    private(set) var collection: T
    
    init(collection: T) {
        self.collection = collection
    }
}
