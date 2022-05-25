//
//  Board.swift
//  Emerald
//
//  Created by Cristian Diaz on 14.5.2022.
//

import Combine
import Foundation
import SpriteKit

public protocol Board: Node {
    
    var spaces: [AnySpace] { get }
    
    var isLocked: Bool { get set }
    
    var uponMessage: AnyPublisher<BoardMessage, Never> { get }
    
    func addSpace(_ space: AnySpace)
    func bridge(_ other: Self)
}
