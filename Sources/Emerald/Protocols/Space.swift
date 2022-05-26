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
    
    func pickToken(at location: CGPoint) -> Token?
    
    func accepts(token: Token) -> Bool
    
    func canPlace(token: Token) -> Bool
    @discardableResult
    func place(token: Token) -> Token?
    
    func arrange()
    
    func purge() -> [Token]
}

public protocol Space: AnySpace {
    
    associatedtype TokenType: Token
    
    func pickToken(at location: CGPoint) -> TokenType?
    
    func accepts(token: TokenType) -> Bool
    
    func canPlace(token: TokenType) -> Bool
    @discardableResult
    func place(token: TokenType) -> TokenType?
}

extension Space {
    
    public func pickToken(at location: CGPoint) -> Token? {
        pickToken(at: location)
    }
    
    public func accepts(token: Token) -> Bool {
        if let concreteToken: TokenType = token as? TokenType {
            return accepts(token: concreteToken)
        }
        
        return false
    }
    
    public func canPlace(token: Token) -> Bool {
        if let concreteToken: TokenType = token as? TokenType {
            return canPlace(token: concreteToken)
        }
        
        return false
    }
    
    public func place(token: Token) -> Token? {
        if let concreteToken: TokenType = token as? TokenType {
            return place(token: concreteToken)
        }
        
        return nil
    }
    
    // MARK: - Internal
    
    
}
