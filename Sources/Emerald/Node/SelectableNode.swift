//
//  SelectableNode.swift
//  Emerald
//
//  Created by Cristian Diaz on 21.4.2022.
//

import Foundation
import SpriteKit

public protocol SelectableNode: Node {
    
    func select(at location: CGPoint)
    func unselect()
}
