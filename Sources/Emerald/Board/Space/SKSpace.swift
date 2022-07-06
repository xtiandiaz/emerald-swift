//
//  SKSpace.swift
//  Emerald
//
//  Created by Cristian Diaz on 25.6.2022.
//

import Beryllium
import Foundation
import SpriteKit

open class SKSpace<T: Token>: AnySpace {
    
    open override func canInteractWithAny(token: AnyToken) -> Bool {
        with(token as? T) { canInteractWith(token: $0) } without: { false }
    }
    
    open override func canInteractWithAny(token: AnyToken, at localPosition: CGPoint) -> Bool {
        with(token as? T) { canInteractWith(token: $0, at: localPosition) } without: { false }
    }
    
    open func canInteractWith(token: T) -> Bool {
        fatalError("Not implemented")
    }
    
    open func canInteractWith(token: T, at localPosition: CGPoint) -> Bool {
        peek(at: localPosition)?.canInteractWith(other: token) == true
    }
    
    open override func interactWithAny(token: AnyToken) {
        with(token as? T) { interactWith(token: $0) }
    }
    
    open override func interactWithAny(token: AnyToken, at localPosition: CGPoint) {
        with(token as? T) { interactWith(token: $0, at: localPosition) }
    }
    
    open func interactWith(token: T) {
        fatalError("Not implemented")
    }
    
    open func interactWith(token: T, at localPosition: CGPoint) {
        peek(at: localPosition)?.interactWith(other: token)
    }
    
    open override func canSwapWithAny(token: AnyToken) -> Bool {
        with(token as? T) { canSwapWith(token: $0) } without: { false }
    }
    
    open override func canSwapWithAny(token: AnyToken, at localPosition: CGPoint) -> Bool {
        with(token as? T) { canSwapWith(token: $0, at: localPosition) } without: { false }
    }
    
    open override func canPlaceAny(token: AnyToken) -> Bool {
        with(token as? T) { canPlace(token: $0) } without: { false }
    }
    
    open func canPlace(token: T) -> Bool {
        fatalError("Not implemented")
    }
    
    open override func placeAny(token: AnyToken) {
        with(token as? T) { place(token: $0) }
    }
    
    // MARK: - Public
    
    public func canSwapWith(token: T) -> Bool {
        fatalError("Not implemented")
    }
    
    public func canSwapWith(token: T, at localPosition: CGPoint) -> Bool {
        peek(at: localPosition)?.canSwapWith(other: token) == true
    }
    
    public func peek(at localPosition: CGPoint) -> T? {
        fatalError("Not implemented")
    }
    
    public func take(at localPosition: CGPoint) -> T? {
        fatalError("Not implemented")
    }
    
    public func place(token: T) {
        fatalError("Not implemented")
    }
    
    public func setTokensLocked(_ locked: Bool, where predicate: (T) -> Bool) {
        fatalError("Not implemented")
    }
    
    // MARK: - Internal
    
    override func peekAny(at localPosition: CGPoint) -> AnyToken? {
        peek(at: localPosition)
    }
    
    override func takeAny(at localPosition: CGPoint) -> AnyToken? {
        take(at: localPosition)
    }
    
    func place(token: T, _ storageHandler: (T) -> Void) {
        guard canPlace(token: token) else {
            return
        }
        
        token.move(toParent: self)
        storageHandler(token)
        
        arrange()
    }
    
    override func restoreAny(token: AnyToken) {
        with(token as? T) { restore(token: $0) }
    }
    
    func restore(token: T) {
        fatalError("Not implemented")
    }
}

extension SKSpace {
    
    public func setTokensLocked(_ locked: Bool) {
        setTokensLocked(locked) { _ in true }
    }
}

