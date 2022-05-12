//
//  CardAreaNode.swift
//  Emerald
//
//  Created by Cristian Diaz on 12.5.2022.
//

import Foundation

open class CardAreaNode<Collection: CardCollection>: Node {
    
    public let collection: Collection
    
    public var isDirty = false
    
    public init(collection: Collection) {
        self.collection = collection
        
        super.init()
    }
    
    open func arrange() {
    }
}

open class StackAreaNode: CardAreaNode<CardStack> {
    
    public init() {
        super.init(collection: CardStack())
    }
    
    public func push(_ node: CardNode) {
        collection.push(node)
        
        addChild(node)
    }
    
    public func pop() -> CardNode? {
        if let node = collection.pop() as? CardNode {
            node.removeFromParent()
            return node
        }
        
        return nil
    }
    
    public func peek() -> CardNode? {
        collection.first as? CardNode
    }
}
