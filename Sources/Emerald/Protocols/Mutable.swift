//
//  Mutable.swift
//  Emerald
//
//  Created by Cristian Diaz on 25.5.2022.
//

import Foundation

public protocol Mutable: Node {
    
    func canMutate(with other: Self) -> Bool
    func mutate(with other: Self)
}
