//
//  Token.swift
//  Emerald
//
//  Created by Cristian Diaz on 14.5.2022.
//

import Foundation

public enum TokenType {
    
    case card
}

public protocol Token: Node {
    
    var type: TokenType { get }
}

extension Token {
    
    func asCard<T: Card>() -> T? {
        type == .card ? self as? T : nil
    }
}
