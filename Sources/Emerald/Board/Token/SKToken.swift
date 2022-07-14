//
//  SKToken.swift
//  Emerald
//
//  Created by Cristian Diaz on 25.6.2022.
//

import Foundation

public protocol SKToken: SKAnyToken {
    
    func canInteractWith(other: Self) -> Bool
    func interactWith(other: Self)
    
    func canSwapWith(other: Self) -> Bool
}

public protocol SKCard: SKToken, Flippable {
    
    associatedtype CardType
    
    var type: CardType { get }
}
