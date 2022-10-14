//
//  SKCard.swift
//  Emerald
//
//  Created by Cristian Diaz on 12.10.2022.
//

import Foundation
import SpriteKit

public protocol SKCard: SKToken, Flippable {
    
    associatedtype CardType
    
    var type: CardType { get }
}
