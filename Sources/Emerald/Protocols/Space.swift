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
    
    func pickToken(at location: CGPoint) -> Token?
    
    func accepts(token: Token) -> Bool
    @discardableResult
    func place(token: Token) -> Bool
    
    func arrange()
    
//    func supportsOptions(forToken token: Token) -> Bool
    
    func setHighlighted(_ highlighted: Bool)
}

public protocol CardSpace: Space {
    
    associatedtype CardType: Card
    
    func pickCard(at location: CGPoint) -> CardType?
    
    func accepts(card: CardType) -> Bool
    func place(card: CardType) -> Bool
    
//    func supportsOptions(forCard card: CardType) -> Bool
//    func apply(card: CardType)
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
    
    public func place(token: Token) -> Bool {
        if let card: CardType = token.asCard() {
            return place(card: card)
        }
        
        return false
    }
}
