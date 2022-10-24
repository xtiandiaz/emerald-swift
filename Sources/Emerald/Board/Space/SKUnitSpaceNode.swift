//
//  SKUnitSpaceNode.swift
//  Emerald
//
//  Created by Cristian Diaz on 26.5.2022.
//

import Foundation
import SpriteKit

open class SKUnitSpaceNode<TokenType: SKTokenNode>: SKSpaceNode {
    
    open func canInteractWithOther(_ other: SKUnitSpaceNode<TokenType>) -> Bool {
        if let otherToken = other.token {
            return canInteractWithToken(otherToken)
        }
        
        return false
    }
    
    open func canInteractWithToken(_ token: TokenType) -> Bool {
        self.token?.canInteractWithOther(token) ?? false
    }
    
    open func interactWithToken(_ token: TokenType) {
        fatalError("Not implemented")
    }
    
    open func canPlaceToken(_ token: TokenType) -> Bool {
        self.token.isNil
    }
    
    open func placeToken(_ token: TokenType) {
        guard canPlaceToken(token) else {
            assertionFailure("Cannot place token")
            return
        }
        
        self.token = token
        
        if token.parent.isNil {
            addChild(token)
        } else {
            token.move(toParent: self)
        }
    }
    
    open func releaseToken(_ token: TokenType) {
        if self.token == token {
            self.token = nil
        }
    }
    
    // MARK: - Public
    
    public private(set) var token: TokenType?
    
    public var tokenCapacity: Int {
        1
    }
    
    public var tokenCount: Int {
        token.isNil ? 0 : 1
    }
    
    public func peek() -> TokenType? {
        token
    }
}
