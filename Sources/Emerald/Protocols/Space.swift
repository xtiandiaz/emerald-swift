//
//  Space.swift
//  Emerald
//
//  Created by Cristian Diaz on 14.5.2022.
//

import Foundation
import SpriteKit

public protocol AnySpace: Node, Highlightable {
    
    var capacity: Int { get }
    var isEmpty: Bool { get }
    
    func pickToken(at location: CGPoint) -> AnyToken?
    
    func accepts(token: AnyToken) -> Bool
    
    func canSwap(with token: AnyToken) -> Bool
    func swap(with token: AnyToken) -> AnyToken?
    
    func canMutate(with token: AnyToken) -> Bool
    func mutate(with token: AnyToken)
    
    func canPlace(token: AnyToken) -> Bool
    func place(token: AnyToken)
    
    func arrange()
    
    func purge() -> [AnyToken]
}

public protocol Space: AnySpace {
    
    associatedtype TokenType: Token
    
    func pickToken(at location: CGPoint) -> TokenType?
    
    func accepts(token: TokenType) -> Bool
    
    func canSwap(with token: TokenType) -> Bool
    func swap(with token: TokenType) -> TokenType?
    
    func canMutate(with token: TokenType) -> Bool
    func mutate(with token: TokenType)
    
    func canPlace(token: TokenType) -> Bool
    func place(token: TokenType)
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
    
    public func place(token: AnyToken) {
        if let t: TokenType = token as? TokenType {
            place(token: t)
        }
    }
    
    // MARK: - Internal
    
    func place(token: TokenType, _ storageHandler: (TokenType) -> Void) {
        guard canPlace(token: token) else {
            return
        }
        
        token.move(toParent: self)
        
        storageHandler(token)
        
        arrange()
    }
}
