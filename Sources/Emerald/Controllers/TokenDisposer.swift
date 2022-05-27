//
//  TokenDisposer.swift
//  Emerald
//
//  Created by Cristian Diaz on 23.5.2022.
//

import Foundation
import SpriteKit

struct TokenDisposer {
    
    func disposeIfInvalidatedOf(token: AnyToken) {
        if token.isInvalidated {
            disposeOf(token: token)
        }
    }
    
    func disposeOf(token: AnyToken) {
        if let disposalAction = token.disposalAction() {
            token.run(disposalAction, withKey: "disposal") { [unowned token] in
                token.removeFromParent()
            }
        } else {
            token.removeFromParent()
        }
    }
}
