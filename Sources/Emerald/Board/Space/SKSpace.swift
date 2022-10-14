//
//  SKSpace.swift
//  Emerald
//
//  Created by Cristian Diaz on 25.6.2022.
//

import Beryllium
import Foundation
import SpriteKit

public protocol _Token: Identifiable, Equatable {
    
    var id: UUID { get }
    var isInvalidated: Bool { get }
    
    func canInteractWith(other: Self) -> Bool
    func interactWith(other: Self)
    
    func invalidate()
    
    func disposalAction() -> SKAction?
}

extension _Token {
    
    public func disposalAction() -> SKAction? {
        .fadeOut(withDuration: 0.25)
    }
}

public protocol _Space: Identifiable, Equatable {
    
    associatedtype TokenType: _Token
    
    var id: UUID { get }
    var tokenCapacity: Int { get }
    var tokenCount: Int { get }
    
    func canPlace(token: TokenType) -> Bool
    func place(token: TokenType)
    
    func release(token: TokenType)
    
    func canInteractWith(other: Self) -> Bool
    
    func canInteractWith(token: TokenType) -> Bool
    func canInteractWithAny(token: any _Token) -> Bool
    
    func setHighlighted(_ highlighted: Bool)
}

extension _Space {
    
    public var isEmpty: Bool {
        tokenCount == 0
    }
    
    public func canInteractWithAny(token: any _Token) -> Bool {
        if let token = token as? TokenType  {
            return canInteractWith(token: token)
        }
        
        return false
    }
}

public protocol _Section: Identifiable, Equatable {
    
    associatedtype SpaceType: _Space
    
    var id: UUID { get }
    
    func spaceAt(localPosition: CGPoint) -> SpaceType?
}

public protocol _Board: Identifiable {
    
    var id: UUID { get }
    
    func add(section: any _Section)
    func add(space: any _Space)
    
    func tokenAt(location: CGPoint) -> (any _Token)?
    func spaceAt(location: CGPoint) -> (any _Space)?
}

open class SKSpace<T: SKToken>: SKAnySpace {
    
    open override func canInteractWithAny(token: SKAnyToken) -> Bool {
        with(token as? T) { canInteractWith(token: $0) } without: { false }
    }
    
    open override func canInteractWithAny(token: SKAnyToken, at localPosition: CGPoint) -> Bool {
        with(token as? T) { canInteractWith(token: $0, at: localPosition) } without: { false }
    }
    
    open func canInteractWith(token: T) -> Bool {
        fatalError("Not implemented")
    }
    
    open func canInteractWith(token: T, at localPosition: CGPoint) -> Bool {
        peek(at: localPosition)?.canInteractWith(other: token) == true
    }
    
    open override func interactWithAny(token: SKAnyToken) {
        with(token as? T) { interactWith(token: $0) }
    }
    
    open override func interactWithAny(token: SKAnyToken, at localPosition: CGPoint) {
        with(token as? T) { interactWith(token: $0, at: localPosition) }
    }
    
    open func interactWith(token: T) {
        fatalError("Not implemented")
    }
    
    open func interactWith(token: T, at localPosition: CGPoint) {
        peek(at: localPosition)?.interactWith(other: token)
    }
    
    open override func canSwapWithAny(token: SKAnyToken) -> Bool {
        with(token as? T) { canSwapWith(token: $0) } without: { false }
    }
    
    open override func canSwapWithAny(token: SKAnyToken, at localPosition: CGPoint) -> Bool {
        with(token as? T) { canSwapWith(token: $0, at: localPosition) } without: { false }
    }
    
    open override func canPlaceAny(token: SKAnyToken) -> Bool {
        with(token as? T) { canPlace(token: $0) } without: { false }
    }
    
    open func canPlace(token: T) -> Bool {
        fatalError("Not implemented")
    }
    
    open override func placeAny(token: SKAnyToken) {
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
    
    override func peekAny(at localPosition: CGPoint) -> SKAnyToken? {
        peek(at: localPosition)
    }
    
    override func takeAny(at localPosition: CGPoint) -> SKAnyToken? {
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
    
    override func restoreAny(token: SKAnyToken) {
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

