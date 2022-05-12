//
//  CardAreaNode.swift
//  Emerald
//
//  Created by Cristian Diaz on 12.5.2022.
//

import Combine
import Foundation
import SpriteKit

public protocol CardSpot: Node {
    
    var id: UUID { get }
    
    func pick() -> CardNode?
    func drop(_ cardNode: CardNode)
    
    func arrange()
    
    func contains(point: CGPoint, fromNode node: SKNode) -> Bool
}

extension CardSpot {
    
    public func contains(point: CGPoint, fromNode node: SKNode) -> Bool {
        contains(convert(point, from: node))
    }
}

func == (lhs: CardSpot, rhs: CardSpot) -> Bool {
    lhs.id == rhs.id
}

func != (lhs: CardSpot, rhs: CardSpot) -> Bool {
    lhs.id != rhs.id
}
