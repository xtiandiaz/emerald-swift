//
//  DraggableNode.swift
//  Emerald
//
//  Created by Cristian Diaz on 21.4.2022.
//

import Foundation
import SpriteKit

public protocol DraggableNode: Node {
    
    var dragAxis: Axis { get }
    var dragOffset: CGPoint { get set }
    
    func pick()
    func drag(to location: CGPoint)
    func drop()
}
