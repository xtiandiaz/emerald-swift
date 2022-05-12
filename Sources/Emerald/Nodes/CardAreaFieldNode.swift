//
//  CardAreaFieldNode.swift
//  Emerald
//
//  Created by Cristian Diaz on 12.5.2022.
//

import Foundation
import SpriteKit

open class CardAreaFieldNode: Node {
    
    open override var frame: CGRect {
        baseNode.frame
    }
    
    public init(size: CGSize) {
        baseNode = SKShapeNode(rect: CGRect(origin: .zero, size: size)).configure {
            $0.fillColor = .green.withAlphaComponent(0.25)
        }
        
        super.init()
        
        isUserInteractionEnabled = true
        
        addChild(baseNode)
    }
    
    open func add(area: CardSpot) {
        guard !contains(area) else {
            return
        }
        
        areas.append(area)
        
        addChild(area)
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard
            let touch = touches.first,
            let source = area(at: touch.location(in: self)),
            let cardNode = source.pick()
        else {
            return
        }
                
        pick = (node: cardNode, offset: touch.location(in: cardNode.parent!), source: source)
        
        cardNode.move(toParent: self)
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard
            let pick = pick,
            let location = touches.first?.location(in: self)
        else {
            return
        }
        
        pick.node.position = location - pick.offset
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard
            let location = touches.first?.location(in: self),
            let pick = pick
        else {
            return
        }
        
        let destination = area(at: location)
        print(destination)
        
        if let destination = destination {
            destination.drop(pick.node)
        } else {
            pick.source.drop(pick.node)
        }
        
        self.pick = nil
    }
    
    public func area(at point: CGPoint) -> CardSpot? {
        areas.first { $0.contains(point) }
    }
    
    // MARK: - Internal
    
    typealias Pick = (node: CardNode, offset: CGPoint, source: CardSpot)
    
    // MARK: - Private
    
    private let baseNode: SKNode
    
    private var pick: Pick?
    private var areas = [CardSpot]()
    
    private func contains(_ area: CardSpot) -> Bool {
        areas.firstIndex { $0 == area } != nil
    }
}
