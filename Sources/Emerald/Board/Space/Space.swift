//
//  Space.swift
//  Emerald
//
//  Created by Cristian Diaz on 18.10.2022.
//

import Foundation

public protocol Space: Identifiable, Equatable {
    
    associatedtype TokenType: Token
    
    var id: UUID { get }
    var tokenCapacity: Int { get }
    var tokenCount: Int { get }
    
    func canPlace(token: TokenType) -> Bool
    func place(token: TokenType)
    
    func release(token: TokenType)
    
    func canInteractWith(other: Self) -> Bool
    
    func canInteractWith(token: TokenType) -> Bool
    func canInteractWithAny(token: any Token) -> Bool
    
    func setHighlighted(_ highlighted: Bool)
}

extension Space {
    
    public var isEmpty: Bool {
        tokenCount == 0
    }
    
    public func canInteractWithAny(token: any Token) -> Bool {
        if let token = token as? TokenType  {
            return canInteractWith(token: token)
        }
        
        return false
    }
}

