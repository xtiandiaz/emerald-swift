//
//  Space.swift
//  Emerald
//
//  Created by Cristian Diaz on 25.6.2022.
//

import Beryllium
import Foundation
import SpriteKit

open class Space<T: AnyToken>: AnySpace {
    
    override open func shouldForwardAny(token: AnyToken) -> Bool {
        with(token as? T) { shouldForward(token: $0) } without: { false }
    }
    
    open func shouldForward(token: T) -> Bool {
        false
    }
    
    open override func canInteractWithAny(token: AnyToken, at localPosition: CGPoint) -> Bool {
        with(token as? T) { canInteractWith(token: $0, at: localPosition) } without: { false }
    }
    
    open func canInteractWith(token: T, at localPosition: CGPoint) -> Bool {
        fatalError("Not implemented")
    }
    
    open override func interactWithAny(token: AnyToken, at localPosition: CGPoint) {
        with(token as? T) { interactWith(token: $0, at: localPosition) }
    }
    
    open func interactWith(token: T, at localPosition: CGPoint) {
        fatalError("Not implemented")
    }
    
    open override func canSwapWithAny(token: AnyToken, at localPosition: CGPoint) -> Bool {
        with(token as? T) { canSwapWith(token: $0, at: localPosition) } without: { false }
    }
    
    open func canSwapWith(token: T, at localPosition: CGPoint) -> Bool {
        fatalError("Not implemented")
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
    
    public func peek(at localPosition: CGPoint) -> T? {
        fatalError("Not implemented")
    }
    
    public func take(at localPosition: CGPoint) -> T? {
        fatalError("Not implemented")
    }
    
    public func place(token: T) {
        fatalError("Not implemented")
    }
    
    // MARK: - Internal
    
    override func peekAny(at localPosition: CGPoint) -> AnyToken? {
        peek(at: localPosition)
    }
    
    override func takeAny(at localPosition: CGPoint) -> AnyToken? {
        take(at: localPosition)
    }
    
    func place(token: T, _ storageHandler: @escaping (T) -> Void) {
        guard canPlace(token: token) else {
            return
        }
        
        token.move(toParent: self)
        storageHandler(token)
        
        arrange()
    }
}

