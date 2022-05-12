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
