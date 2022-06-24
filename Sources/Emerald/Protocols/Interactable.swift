//
//  Interactable.swift
//  Emerald
//
//  Created by Cristian Diaz on 24.6.2022.
//

import Foundation

public protocol Interactable {
    
    func canInteractWith(other: Self) -> Bool
    func interactWith(other: Self)
}
