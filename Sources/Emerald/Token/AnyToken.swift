//
//  AnyToken.swift
//  Emerald
//
//  Created by Cristian Diaz on 14.5.2022.
//

import Beryllium
import Foundation
import SpriteKit

open class AnyToken: Node, Selectable {
    
    open var isLocked: Bool {
        false
    }
    
    open var isDisposable: Bool {
        false
    }
    
    open func canInteractWith(other: AnyToken) -> Bool {
        fatalError("Not implemented")
    }
    
    open func interactWith(other: AnyToken) {
        fatalError("Not implemented")
    }
    
    open func setSelected(_ selected: Bool) {
        fatalError("Not implemented")
    }
    
    open func disposalAction() -> SKAction? {
        .fadeOut(withDuration: 0.25)
    }
    
    // MARK: - Public
    
    public var isInvalidated = false
    
    public override init() {
        super.init()
    }
}

extension AnyToken {
    
    public func runIfValid(_ action: SKAction, withKey key: String) {
        if !isInvalidated {
            run(action, withKey: key)
        }
    }
}
