//
//  SKBoard.swift
//  Emerald
//
//  Created by Cristian Diaz on 30.6.2022.
//

import Foundation

public protocol SKBoard: AnyBoard {
    
    associatedtype TokenType: SKToken
    associatedtype SpaceType: SKSpace<TokenType>
    
    var spaces: [SpaceType] { get }
}

extension SKBoard {
    
    public func setTokensLocked(_ locked: Bool, where predicate: (TokenType) -> Bool) {
        spaces.forEach {
            $0.setTokensLocked(locked, where: predicate)
        }
    }
    
    public func arrange() {
        spaces.forEach {
            $0.arrange()
        }
    }
}
