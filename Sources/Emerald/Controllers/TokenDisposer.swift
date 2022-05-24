//
//  TokenDisposer.swift
//  Emerald
//
//  Created by Cristian Diaz on 23.5.2022.
//

import Combine
import Foundation
import SpriteKit

open class TokenDisposer {
    
    public init() {
    }
    
    public func disposeIfInvalidatedOf(token: Token) {
        if token.isInvalidated {
            disposeOf(token: token)
        }
    }
    
    public func disposeOf(token: Token) {
        removeAnimated(token)
    }
    
    open func killAction() -> SKAction {
        .fadeOut(withDuration: 0.25)
    }
    
    // MARK: - Private
    
    private func removeAnimated(_ node: SKNode) {
        node.run(killAction(), withKey: "kill") { [unowned node] in
            node.removeFromParent()
        }
    }
}
