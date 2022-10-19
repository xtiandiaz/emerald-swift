//
//  Token.swift
//  Emerald
//
//  Created by Cristian Diaz on 18.10.2022.
//

import Foundation
import SpriteKit

public protocol Token: Identifiable, Equatable {
    
    var id: UUID { get }
    var isInvalidated: Bool { get }
    
    func canInteractWith(other: Self) -> Bool
    func interactWith(other: Self)
    
    func invalidate()
    
    func disposalAction() -> SKAction?
}

extension Token {
    
    public func disposalAction() -> SKAction? {
        .fadeOut(withDuration: 0.2)
    }
}

