//
//  Fireable.swift
//  Emerald
//
//  Created by Cristian Diaz on 9.5.2022.
//

import Foundation
import SpriteKit

public protocol Fireable: Node {
    
    var canFire: Bool { get }
    
    func charge()
    func fire()
}
