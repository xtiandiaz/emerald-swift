//
//  Card.swift
//  Emerald
//
//  Created by Cristian Diaz on 12.5.2022.
//

import Foundation

public protocol Card {
    
    var value: Int { get set }
    
    var isLocked: Bool { get set }
}
