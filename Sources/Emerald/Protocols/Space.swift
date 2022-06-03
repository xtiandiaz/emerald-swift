//
//  Space.swift
//  Emerald
//
//  Created by Cristian Diaz on 14.5.2022.
//

import Foundation
import SpriteKit

public protocol AnySpace: Node, Highlightable {
    
    var tokenCapacity: Int { get }
    var tokenCount: Int { get }
    
    var isEmpty: Bool { get }
    
    func pickToken(at location: CGPoint) -> AnyToken?
    
    func accepts(token: AnyToken) -> Bool
    
    func shouldForward(token: AnyToken) -> Bool
    
    func canSwap(with token: AnyToken) -> Bool
    func swap(with token: AnyToken) -> AnyToken?
    
    func canMutate(with token: AnyToken) -> Bool
    func mutate(with token: AnyToken)

    func canPlace(token: AnyToken) -> Bool
    @discardableResult
    func place(token: AnyToken) -> Bool
    
    func arrange()
    
    func purge() -> [AnyToken]
}

public protocol Space: AnySpace {
    
    associatedtype TokenType: Token
    
    func pickToken(at location: CGPoint) -> TokenType?
    
    func accepts(token: TokenType) -> Bool
    
    func shouldForward(token: TokenType) -> Bool
    
    func canSwap(with token: TokenType) -> Bool
    func swap(with token: TokenType) -> TokenType?
    
    func canMutate(with token: TokenType) -> Bool
    func mutate(with token: TokenType)
    
    func canPlace(token: TokenType) -> Bool
    @discardableResult
    func place(token: TokenType) -> Bool
}

extension AnySpace {
    
    public func setHighlighted(_ highlighted: Bool, for token: AnyToken) {
        setHighlighted(highlighted && token.canBeUsedOn(space: self))
    }
}

extension Space {
    
    public func pickToken(at location: CGPoint) -> AnyToken? {
        pickToken(at: location)
    }
    
    public func accepts(token: AnyToken) -> Bool {
        if let t: TokenType = token as? TokenType {
            return accepts(token: t)
        }
        
        return false
    }
    
    public func shouldForward(token: AnyToken) -> Bool {
        if let t: TokenType = token as? TokenType {
            return shouldForward(token: t)
        }
        
        return false
    }
    
    public func canSwap(with token: AnyToken) -> Bool {
        if let t: TokenType = token as? TokenType {
            return canSwap(with: t)
        }
        
        return false
    }
    
    public func swap(with token: AnyToken) -> AnyToken? {
        if let t: TokenType = token as? TokenType {
            return swap(with: t)
        }

        return nil
    }

    public func canMutate(with token: AnyToken) -> Bool {
        if let t: TokenType = token as? TokenType {
            return canMutate(with: t)
        }

        return false
    }

    public func mutate(with token: AnyToken) {
        if let t: TokenType = token as? TokenType {
            mutate(with: t)
        }
    }
    
    public func canPlace(token: AnyToken) -> Bool {
        if let t: TokenType = token as? TokenType {
            return canPlace(token: t)
        }
        
        return false
    }
    
    public func place(token: AnyToken) -> Bool {
        if let t: TokenType = token as? TokenType {
            place(token: t)
            return true
        }
        
        return false
    }
    
    // MARK: - Internal
    
    func place(token: TokenType, _ storageHandler: (TokenType) -> Void) -> Bool {
        guard canPlace(token: token) else {
            return false
        }
        
        token.move(toParent: self)
        storageHandler(token)
        arrange()
        
        return true
    }
}
