//
//  CardMask.swift
//  Emerald
//
//  Created by Cristian Diaz on 13.5.2022.
//

import Foundation

public protocol CardMask {
    
    associatedtype CardType: Card
    
    func accepts(card: CardType) -> Bool
}
