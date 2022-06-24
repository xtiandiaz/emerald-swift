//
//  Swappable.swift
//  Emerald
//
//  Created by Cristian Diaz on 24.6.2022.
//

import Foundation

public protocol Swappable {
    
    func canSwapWith(other: Self) -> Bool
}
