//
//  TokenMove.swift
//  Emerald
//
//  Created by Cristian Diaz on 23.5.2022.
//

import Foundation

public enum TokenMove {
    
    case place,
         swap(with: Token),
         interact(with: Token)
}
