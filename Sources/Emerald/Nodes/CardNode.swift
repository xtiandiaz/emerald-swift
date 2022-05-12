//
//  CardNode.swift
//  Emerald
//
//  Created by Cristian Diaz on 12.5.2022.
//

import Foundation

open class CardNode: Node, Card {
    
    public let id = UUID()
    
    public var value: Int
    
    open var isLocked = false
    
    public init(value: Int) {
        self.value = value
        
        super.init()        
    }
}

open class DraggableCardNode: CardNode, Draggable {
    
    open var dragAxis: Axis {
        .xy
    }
    
    open override var isLocked: Bool {
        get { !dragging.isRunning }
        set { newValue ? dragging.stop() : dragging.start() }
    }
    
    public override init(value: Int) {
        super.init(value: value)
        
        dragging.start()
    }
    
    open func pick() {
        print("-- Picked --")
    }
    
    open func drop() {
        print("-- Dropped --")
    }
    
    // MARK: - Private
    
    private lazy var dragging = DraggingBehavior(node: self)
}
