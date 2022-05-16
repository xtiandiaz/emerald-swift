//
//  Token.swift
//  Emerald
//
//  Created by Cristian Diaz on 14.5.2022.
//

import Foundation
import SpriteKit

public enum TokenType {
    
    case card
}

public protocol Token: Node {
    
    var type: TokenType { get }
    
    var supportsOptions: Bool { get }
    var isInvalidated: Bool { get }
    
    func setSelected(_ selected: Bool)
    
    func showOptions()
}

extension Token {
    
    public func runIfValid(_ action: SKAction, withKey key: String) {
        if !isInvalidated {
            run(action, withKey: key)
        }
    }
    
    // MARK: - Internal
    
    func asCard<T: Card>() -> T? {
        type == .card ? self as? T : nil
    }
}
