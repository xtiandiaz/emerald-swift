//
//  Board.swift
//  Emerald
//
//  Created by Cristian Diaz on 30.6.2022.
//

import Foundation

public protocol Board: AnyBoard {
    
    associatedtype TokenType: Token
    associatedtype SpaceType: SKSpace<TokenType>
    
    var spaces: [SpaceType] { get }
}

extension Board {
    
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
