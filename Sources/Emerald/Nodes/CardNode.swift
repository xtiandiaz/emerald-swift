//
//  CardNode.swift
//  Emerald
//
//  Created by Cristian Diaz on 12.5.2022.
//

import Foundation

open class CardNode: Node, Card {
    
    public var value: Int
    
    public var isLocked: Bool {
        get { isUserInteractionEnabled }
        set { isUserInteractionEnabled = newValue }
    }
    
    public init(value: Int) {
        self.value = value
        
        super.init()        
    }
}
