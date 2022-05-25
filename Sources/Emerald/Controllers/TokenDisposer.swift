//
//  TokenDisposer.swift
//  Emerald
//
//  Created by Cristian Diaz on 23.5.2022.
//

import Foundation
import SpriteKit

class TokenDisposer {
    
    func disposeIfInvalidatedOf(token: Token) {
        if token.isInvalidated {
            disposeOf(token: token)
        }
    }
    
    func disposeOf(token: Token) {
        disposeAnimatedOf(token)
    }
    
    // MARK: - Private
    
    private func disposeAnimatedOf(_ token: Token) {
        token.run(token.disposalAction(), withKey: "disposal") { [unowned token] in
            token.removeFromParent()
        }
    }
}
