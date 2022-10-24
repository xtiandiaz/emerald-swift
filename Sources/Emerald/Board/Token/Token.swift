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
    
    func canInteractWithOther(_ other: Self) -> Bool
    func interactWithOther(_ other: Self) -> Self?
    
    func invalidate()
    
    func moveAction(localPosition: Position, duration: TimeInterval, delay: TimeInterval) -> SKAction
    func disposalAction(duration: TimeInterval) -> SKAction?
}

extension Token {
    
    public func moveAction(
        localPosition: Position,
        duration: TimeInterval = 0.1,
        delay: TimeInterval = 0
    ) -> SKAction {
        .moveTo(localPosition: localPosition, duration: 0.1, timingMode: .easeIn)
    }
    
    public func disposalAction(duration: TimeInterval = 0.1) -> SKAction? {
        .fadeOut(withDuration: duration)
    }
}

