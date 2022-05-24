//
//  Space.swift
//  Emerald
//
//  Created by Cristian Diaz on 14.5.2022.
//

import Foundation
import SpriteKit

public protocol Space: Node {
    
    var isLocked: Bool { get set }
    var isEmpty: Bool { get }
    
    func pickToken(at location: CGPoint) -> Token?
    
    func accepts(token: Token) -> Bool
    func move(forToken token: Token) -> TokenMove?
    
    func place(token: Token)
    
    func arrange()
    
    func setHighlighted(_ highlighted: Bool)
}

public protocol CardSpace: Space {
    
    associatedtype CardType: Card
    
    func pickCard(at location: CGPoint) -> CardType?
    
    func accepts(card: CardType) -> Bool
    func move(forCard: CardType) -> TokenMove?
    
    func place(card: CardType)
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
    
    public func move(forToken token: Token) -> TokenMove? {
        if let card: CardType = token.asCard() {
            return move(forCard: card)
        }
        
        return nil
    }
    
    public func place(token: Token) {
        if let card: CardType = token.asCard() {
            return place(card: card)
        }
    }
}
