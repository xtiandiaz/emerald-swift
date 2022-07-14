//
//  SKAnyToken.swift
//  Emerald
//
//  Created by Cristian Diaz on 14.5.2022.
//

import Beryllium
import Foundation
import SpriteKit

open class SKAnyToken: Node {
    
    open var isLocked = false
    
    open var isDisposable: Bool {
        false
    }
    
    open func canInteractWithAny(other: SKAnyToken) -> Bool {
        fatalError("Not implemented")
    }
    
    open func interactWithAny(other: SKAnyToken) {
        fatalError("Not implemented")
    }
    
    open func canSwapWithAny(other: SKAnyToken) -> Bool {
        fatalError("Not implemented")
    }
    
    open func setSelected(_ selected: Bool) {
        fatalError("Not implemented")
    }
    
    open func disposalAction() -> SKAction? {
        .fadeOut(withDuration: 0.25)
    }
    
    open func invalidate() {
        isInvalidated = true
    }
    
    // MARK: - Public
    
    public private(set) var isInvalidated = false
    
    public override init() {
        super.init()
    }
}

extension SKAnyToken {
    
    public func runIfValid(_ action: SKAction, withKey key: String) {
        if !isInvalidated {
            run(action, withKey: key)
        }
    }
}
