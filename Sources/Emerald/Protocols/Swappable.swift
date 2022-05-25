//
//  Swappable.swift
//  Emerald
//
//  Created by Cristian Diaz on 25.5.2022.
//

import Foundation

public protocol Swappable: Node {
    
    func canSwap(with other: Self) -> Bool
}
