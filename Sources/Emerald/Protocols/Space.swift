//
//  Space.swift
//  Emerald
//
//  Created by Cristian Diaz on 14.5.2022.
//

import Foundation
import SpriteKit

public protocol Space: Node, Highlightable {
    
    var isLocked: Bool { get set }
    var isEmpty: Bool { get }
    
    func pickToken(at location: CGPoint) -> Token?
    
    func accepts(token: Token) -> Bool
    
    @discardableResult
    func place(token: Token) -> Token?
    
    func arrange()
}

public protocol CardSpace: Space {
    
    associatedtype CardType: Card
    
    func pickCard(at location: CGPoint) -> CardType?
    
    func accepts(card: CardType) -> Bool
    
    func place(card: CardType) -> CardType?
}

extension CardSpace {
    
    public func pickToken(at location: CGPoint) -> Token? {
        pickCard(at: location)
    }
    
    public func accepts(token: Token) -> Bool {
        if let card: CardType = token.asCard() {
            return accepts(card: card)
        }
        
        return false
    }
    
    public func place(token: Token) -> Token? {
        if let card: CardType = token.asCard() {
            return place(card: card)
        }
        
        return nil
    }
}
