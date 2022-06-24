//
//  Card.swift
//  Emerald
//
//  Created by Cristian Diaz on 24.6.2022.
//

import Foundation

public protocol Card: AnyToken, Flippable {
    
    associatedtype CardType
    
    var type: CardType { get }
}
