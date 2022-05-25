//
//  Board.swift
//  Emerald
//
//  Created by Cristian Diaz on 14.5.2022.
//

import Foundation
import SpriteKit

public protocol Board: Node {
    
    var spaces: [AnySpace] { get }
    
    var isLocked: Bool { get set }
    
    func addSpace(_ space: AnySpace)
    func bridge(_ other: Self)
}
