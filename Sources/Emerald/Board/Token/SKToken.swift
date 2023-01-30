//
//  SKToken.swift
//  Emerald
//
//  Created by Cristian Diaz on 25.6.2022.
//

import Foundation
import SpriteKit

public protocol SKToken: SKAnyToken {
    
    var isInvalidated: Bool { get }
    
    func canInteractWith(other: Self) -> Bool
    func interactWith(other: Self)
    
    func canSwapWith(other: Self) -> Bool
    
    func setSelected(_ selected: Bool)
    
    func invalidate()
    
    func disposalAction() -> SKAction?
}

extension SKToken {
    
    public func disposalAction() -> SKAction? {
        .fadeOut(withDuration: 0.25)
    }
}

//open class SKTokenNode: SKNode, SKToken {
//    
//    open var isLocked = false
//    
//    open var isDisposable: Bool {
//        false
//    }
//    
//    open func canInteractWith(other: SKTokenNode) -> Bool {
//        fatalError("Not implemented")
//    }
//    
//    open func interactWith(other: SKTokenNode) {
//        fatalError("Not implemented")
//    }
//    
//    open func canSwapWith(other: SKTokenNode) -> Bool {
//        fatalError("Not implemented")
//    }
//    
//    open func setSelected(_ selected: Bool) {
//        fatalError("Not implemented")
//    }
//    
//    open func disposalAction() -> SKAction? {
//        .fadeOut(withDuration: 0.25)
//    }
//    
//    open func invalidate() {
//        isInvalidated = true
//    }
//    
//    // MARK: - Public
//    
//    public private(set) var isInvalidated = false
//    
//    public override init() {
//        super.init()
//    }
//}
//
extension SKToken {
    
    public func runIfValid(_ action: SKAction, withKey key: String) {
        if !isInvalidated {
            run(action, withKey: key)
        }
    }
}
