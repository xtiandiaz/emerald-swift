//
//  Token.swift
//  Emerald
//
//  Created by Cristian Diaz on 14.5.2022.
//

import Foundation
import SpriteKit

public enum TokenType {
    
    case card
}

public protocol AnyToken: Node {
    
    var type: TokenType { get }
    
    var isLocked: Bool { get }
    var isDisposable: Bool { get }
    var isInvalidated: Bool { get }
    
    var supportsOptions: Bool { get }
    
    func showOptions()
    
    func invalidate()
    
    func disposalAction() -> SKAction?
}

public protocol Token: AnyToken {

    func canSwap(with other: Self) -> Bool

    func canMutate(with other: Self) -> Bool
    func mutate(with other: Self)
}

extension AnyToken {
    
    public var isDisposable: Bool {
        false
    }
    
    public func canBeUsedOn(space: AnySpace) -> Bool {
        space.canPlace(token: self) || space.canSwap(with: self) || space.canMutate(with: self)
    }
    
    public func disposalAction() -> SKAction? {
        .fadeOut(withDuration: 0.25)
    }
    
    public func runIfValid(_ action: SKAction, withKey key: String) {
        if !isInvalidated {
            run(action, withKey: key)
        }
    }
}
