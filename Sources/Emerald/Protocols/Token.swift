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

public protocol Token: Node {
    
    var type: TokenType { get }
    
    var supportsOptions: Bool { get }
    var isLocked: Bool { get }
    var isDisposable: Bool { get }
    var isInvalidated: Bool { get }
    
    func showOptions()
    
    func invalidate()
    
    func disposalAction() -> SKAction
}

extension Token {
    
    public var isDisposable: Bool {
        false
    }
    
    public func disposalAction() -> SKAction {
        .fadeOut(withDuration: 0.25)
    }
    
    public func runIfValid(_ action: SKAction, withKey key: String) {
        if !isInvalidated {
            run(action, withKey: key)
        }
    }
}
