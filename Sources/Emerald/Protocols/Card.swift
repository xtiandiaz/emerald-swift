//
//  Card.swift
//  Emerald
//
//  Created by Cristian Diaz on 12.5.2022.
//

import Foundation

public protocol Card {
    
    var id: UUID { get }
    var value: Int { get set }
    
    var isLocked: Bool { get set }
}

func == (lhs: Card, rhs: Card?) -> Bool {
    lhs.id == rhs?.id
}
