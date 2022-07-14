//
//  TokenDisposer.swift
//  Emerald
//
//  Created by Cristian Diaz on 23.5.2022.
//

import Foundation
import SpriteKit

public struct TokenDisposer {
    
    public init() {
    }
    
    public func disposeIfInvalidatedOf(tokens: [SKAnyToken]) {
        tokens.forEach {
            disposeIfInvalidatedOf(token: $0)
        }
    }
    
    public func disposeIfInvalidatedOf(token: SKAnyToken) {
        if token.isInvalidated {
            disposeOf(token: token)
        }
    }
    
    public func disposeOf(tokens: [SKAnyToken]) {
        tokens.forEach {
            disposeOf(token: $0)
        }
    }
    
    public func disposeOf(token: SKAnyToken) {
        if let disposalAction = token.disposalAction() {
            token.run(disposalAction, withKey: "disposal") { [unowned token] in
                token.removeFromParent()
            }
        } else {
            token.removeFromParent()
        }
    }
}
