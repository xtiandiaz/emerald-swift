//
//  CardStackNode.swift
//  Emerald
//
//  Created by Cristian Diaz on 12.5.2022.
//

import Beryllium
import Foundation

open class CardStackNode: Node, CardSpot {
    
    public let id = UUID()
    
    public func pick() -> CardNode? {
        pop()
    }
    
    public func drop(_ cardNode: CardNode) {
        push(cardNode)
    }
    
    public func peek() -> CardNode? {
        stack.peek()
    }
    
    public func push(_ cardNode: CardNode) {
        stack.push(cardNode)
        
        cardNode.move(toParent: self)
        
        arrange()
    }
    
    public func pop() -> CardNode? {
        defer {
            arrange()
        }
        
        return stack.pop()
    }
    
    public func arrange() {
        for node in stack {
            node.position = .zero
        }
    }
    
    // MARK: - Private
    
    private var stack = Stack<CardNode>()
    
}
