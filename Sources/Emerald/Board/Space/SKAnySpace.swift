//
//  SKAnySpace.swift
//  Emerald
//
//  Created by Cristian Diaz on 14.5.2022.
//

import Beryllium
import Foundation
import SpriteKit

open class SKAnySpace: Node, Highlightable {
    
    open var tokenCount: Int {
        fatalError("Not implemented")
    }
    
    open var tokenCapacity: Int {
        fatalError("Not implemented")
    }
    
    open var isEmpty: Bool {
        true
    }
    
    open var isLocked: Bool {
        false
    }
    
    open func shouldForwardAny(token: SKAnyToken) -> Bool {
        fatalError("Not implemented")
    }
    
    open func canInteractWithAny(token: SKAnyToken) -> Bool {
        fatalError("Not implemented")
    }
    
    open func canInteractWithAny(token: SKAnyToken, at localPosition: CGPoint) -> Bool {
        fatalError("Not implemented")
    }
    
    open func interactWithAny(token: SKAnyToken) {
        fatalError("Not implemented")
    }
    
    open func interactWithAny(token: SKAnyToken, at localPosition: CGPoint) {
        fatalError("Not implemented")
    }
    
    open func canSwapWithAny(token: SKAnyToken, at localPosition: CGPoint) -> Bool {
        fatalError("Not implemented")
    }
    
    open func canSwapWithAny(token: SKAnyToken) -> Bool {
        fatalError("Not implemented")
    }
    
    open func canPlaceAny(token: SKAnyToken) -> Bool {
        fatalError("Not implemented")
    }
    
    open func placeAny(token: SKAnyToken) {
        fatalError("Not implemented")
    }
    
    open func arrange() {
        fatalError("Not implemented")
    }
    
    open func purge() -> [SKAnyToken] {
        fatalError("Not implemented")
    }
    
    open func setHighlighted(_ highlighted: Bool) {
        fatalError("Not implemented")
    }
    
    // MARK: - Internal
    
    func peekAny(at localPosition: CGPoint) -> SKAnyToken? {
        fatalError("Not implemented")
    }
    
    func restoreAny(token: SKAnyToken) {
        fatalError("Not implemented")
    }
    
    func takeAny(at localPosition: CGPoint) -> SKAnyToken? {
        fatalError("Not implemented")
    }
}

extension SKAnySpace {
    
    func acceptsAny(token: SKAnyToken, at localPosition: CGPoint) -> Bool {
        canPlaceAny(token: token) ||
        canInteractWithAny(token: token, at: localPosition) ||
        canSwapWithAny(token: token, at: localPosition)
    }
    
    func acceptsAny(token: SKAnyToken) -> Bool {
        canPlaceAny(token: token) ||
        canInteractWithAny(token: token) ||
        canSwapWithAny(token: token)
    }
}
