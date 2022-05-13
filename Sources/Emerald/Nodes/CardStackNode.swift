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
    
    open func arrange() {
        for node in stack {
            node.position = .zero
        }
    }
    
    open func highlight() {
    }
    
    public func pick() -> CardNode? {
        pop()
    }
    
    public func drop(_ cardNode: CardNode) {
        push(cardNode)
    }
    
    public func accepts<T: Card>(card: T) -> Bool {
        return true
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
    
    // MARK: - Private
    
    private var stack = Stack<CardNode>()
    
}
