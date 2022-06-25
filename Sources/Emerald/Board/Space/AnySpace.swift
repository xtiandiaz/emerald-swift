//
//  AnySpace.swift
//  Emerald
//
//  Created by Cristian Diaz on 14.5.2022.
//

import Beryllium
import Foundation
import SpriteKit

open class AnySpace: Node, Highlightable {
    
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
    
    open func shouldForwardAny(token: AnyToken) -> Bool {
        fatalError("Not implemented")
    }
    
    open func canInteractWithAny(token: AnyToken, at localPosition: CGPoint) -> Bool {
        fatalError("Not implemented")
    }
    
    open func interactWithAny(token: AnyToken, at localPosition: CGPoint) {
        fatalError("Not implemented")
    }
    
    open func canPlaceAny(token: AnyToken) -> Bool {
        fatalError("Not implemented")
    }
    
    open func placeAny(token: AnyToken) {
        fatalError("Not implemented")
    }
    
    open func canSwapWithAny(token: AnyToken, at localPosition: CGPoint) -> Bool {
        fatalError("Not implemented")
    }
    
    open func arrange() {
        fatalError("Not implemented")
    }
    
    open func purge() -> [AnyToken] {
        fatalError("Not implemented")
    }
    
    open func setHighlighted(_ highlighted: Bool) {
        fatalError("Not implemented")
    }
    
    // MARK: - Internal
    
    func peekAny(at localPosition: CGPoint) -> AnyToken? {
        fatalError("Not implemented")
    }
    
    func takeAny(at localPosition: CGPoint) -> AnyToken? {
        fatalError("Not implemented")
    }
}

extension AnySpace {
    
    func acceptsAny(token: AnyToken, at localPosition: CGPoint) -> Bool {
        canPlaceAny(token: token) ||
        canInteractWithAny(token: token, at: localPosition) ||
        canSwapWithAny(token: token, at: localPosition) ||
        shouldForwardAny(token: token)
    }
}
