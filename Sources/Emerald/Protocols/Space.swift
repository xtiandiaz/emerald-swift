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
    
    func canPlace(token: Token) -> Bool
    func place(token: Token)
    
    func arrange()
    
    func setHighlighted(_ highlighted: Bool)
}

public protocol CardSpace: Space {
    
    associatedtype CardType: Card
    
    func pickCard(at location: CGPoint) -> CardType?
    
    func canPlace(card: CardType) -> Bool
    func place(card: CardType)
    
    func insert(card: CardType)
}

extension CardSpace {
    
    public func pickToken(at location: CGPoint) -> Token? {
        pickCard(at: location)
    }
    
    public func canPlace(token: Token) -> Bool {
        if let card: CardType = token.asCard() {
            return canPlace(card: card)
        }
        
        return false
    }
    
    public func place(token: Token) {
        if let card: CardType = token.asCard() {
            place(card: card)
        }
    }
}
