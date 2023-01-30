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
    
    func peek() -> TokenType?
    
    func canPlaceToken(_ token: TokenType) -> Bool
    func placeToken(_ token: TokenType)
    
    func releaseToken(_ token: TokenType)
    
    func canInteractWithOther(_ other: Self) -> Bool
    
    func canInteractWithToken(_ token: TokenType) -> Bool
    func interactWithToken(_ token: TokenType)
    func canInteractWithAnyToken(_ token: any Token) -> Bool    
    func interactWithAnyToken(_ token: any Token)
}

extension Space {
    
    public var isEmpty: Bool {
        tokenCount == 0
    }
    
    public func canInteractWithAnyToken(_ token: any Token) -> Bool {
        if let token = token as? TokenType  {
            return canInteractWithToken(token)
        }
        
        return false
    }
    
    public func interactWithAnyToken(_ token: any Token) {
        if let token = token as? TokenType {
            return interactWithToken(token)
        }
    }
}
