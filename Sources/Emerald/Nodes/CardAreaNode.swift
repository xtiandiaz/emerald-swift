//
//  CardAreaNode.swift
//  Emerald
//
//  Created by Cristian Diaz on 12.5.2022.
//

import Foundation
import SpriteKit

open class CardAreaNode: Node {
    
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
    
    public func add(spot: CardSpot) {
        guard !contains(spot) else {
            return
        }
        
        spots.append(spot)
        
        addChild(spot)
    }
    
    public func bridge(area: CardAreaNode) {
        if area != self, !bridgedAreas.contains(area) {
            bridgedAreas.append(area)
            area.bridgedAreas.append(self)
        }
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard
            let touch = touches.first,
            let source = spot(at: touch.location(in: self)),
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
        
        if let localDestination = spot(at: location, for: pick.node) {
            localDestination.drop(pick.node)
        } else if let bridgedDestination = bridgedSpot(at: location, for: pick.node) {
            bridgedDestination.drop(pick.node)
        } else {
            pick.source.drop(pick.node)
        }
        
        self.pick = nil
    }
    
    // MARK: - Private
    
    private typealias Pick = (node: CardNode, offset: CGPoint, source: CardSpot)
    
    private let baseNode: SKNode
    
    private var pick: Pick?
    private var spots = [CardSpot]()
    private var bridgedAreas = [CardAreaNode]()
    
    private func spot(at location: CGPoint) -> CardSpot? {
        spots.first { $0.contains(location) }
    }
    
    private func spot(at location: CGPoint, for cardNode: CardNode) -> CardSpot? {
        if let spot = spot(at: location), spot.accepts(card: cardNode) {
            return spot
        }
        return nil
    }
    
    private func bridgedSpot(at location: CGPoint, for cardNode: CardNode) -> CardSpot? {
        bridgedAreas.compactMap {
            $0.spot(at: $0.convert(location, from: self), for: cardNode)
        }.first
    }
    
    private func contains(_ spot: CardSpot) -> Bool {
        spots.firstIndex { $0 == spot } != nil
    }
}
