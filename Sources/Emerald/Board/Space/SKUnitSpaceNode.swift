//
//  SKUnitSpaceNode.swift
//  Emerald
//
//  Created by Cristian Diaz on 26.5.2022.
//

import Foundation
import SpriteKit

open class SKUnitSpaceNode<TokenType: SKTokenNode>: SKSpaceNode {
    
    open func canInteractWith(other: SKUnitSpaceNode<TokenType>) -> Bool {
        if let otherToken = other.token {
            return canInteractWith(token: otherToken)
        }
        
        return false
    }
    
    open func canInteractWith(token: TokenType) -> Bool {
        self.token?.canInteractWith(other: token) ?? false
    }
    
    open func canPlace(token: TokenType) -> Bool {
        self.token.isNil
    }
    
    open func place(token: TokenType) {
        guard canPlace(token: token) else {
            return
        }
        
        self.token = token
        
        if token.parent.isNil {
            addChild(token)
        } else {
            token.move(toParent: self)
        }
        
        token.run(
            .moveTo(localPosition: .zero, duration: 0.2, timingMode: .easeIn),
            withKey: "move"
        )
    }
    
    open func release(token: TokenType) {
        if self.token == token {
            self.token = nil
        }
    }
    
    open func setHighlighted(_ highlighted: Bool) {
        fatalError("Not implemented")
    }
    
    // MARK: - Public
    
    public private(set) var token: TokenType?
    
    public var tokenCapacity: Int {
        1
    }
    
    public var tokenCount: Int {
        token.isNil ? 0 : 1
    }
}
