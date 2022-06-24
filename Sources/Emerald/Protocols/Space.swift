//
//  Space.swift
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
    
    func canInteractWithAny(token: AnyToken, at localPosition: CGPoint) -> Bool {
        fatalError("Not implemented")
    }
    
    func interactWithAny(token: AnyToken, at localPosition: CGPoint) {
        fatalError("Not implemented")
    }
    
    func canPlaceAny(token: AnyToken) -> Bool {
        fatalError("Not implemented")
    }
    
    func placeAny(token: AnyToken) {
        fatalError("Not implemented")
    }
    
    func canSwapWithAny(token: AnyToken, at localPosition: CGPoint) -> Bool {
        fatalError("Not implemented")
    }
}

extension AnySpace {
    
    func acceptsAny(token: AnyToken, at localPosition: CGPoint) -> Bool {
        canPlaceAny(token: token) ||
        canInteractWithAny(token: token, at: localPosition) ||
        canSwapWithAny(token: token, at: localPosition)
    }
}

open class Space<T: AnyToken>: AnySpace {
    
    open func canPlace(token: T) -> Bool {
        fatalError("Not implemented")
    }
    
    open func canInteractWith(token: T, at localPosition: CGPoint) -> Bool {
        fatalError("Not implemented")
    }
    
    open func interactWith(token: T, at localPosition: CGPoint) {
        fatalError("Not implemented")
    }
    
    open func canSwapWith(token: T, at localPosition: CGPoint) -> Bool {
        fatalError("Not implemented")
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
    
    override func canInteractWithAny(token: AnyToken, at localPosition: CGPoint) -> Bool {
        with(token as? T) { canInteractWith(token: $0, at: localPosition) } without: { false }
    }
    
    override func interactWithAny(token: AnyToken, at localPosition: CGPoint) {
        with(token as? T) { interactWith(token: $0, at: localPosition) }
    }
    
    override func canSwapWithAny(token: AnyToken, at localPosition: CGPoint) -> Bool {
        with(token as? T) { canSwapWith(token: $0, at: localPosition) } without: { false }
    }
    
    override func canPlaceAny(token: AnyToken) -> Bool {
        with(token as? T) { canPlace(token: $0) } without: { false }
    }
    
    override func placeAny(token: AnyToken) {
        with(token as? T) { place(token: $0) }
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

//public protocol Space: AnySpace {
//
//    associatedtype TokenType: Token
//
//    func take(at location: CGPoint) -> TokenType?
//    func pickToken(at location: CGPoint) -> TokenType?
//
//    func take(from other: Self)
//
//    func canPlace(token: TokenType) -> Bool
//    func place(token: TokenType)
//}
//
//extension Space {
//
//    public func pickToken(at location: CGPoint) -> AnyToken? {
//        pickToken(at: location)
//    }
//
//    public func take(at location: CGPoint) -> AnyToken? {
//        take(at: location)
//    }
//
//    public func accepts(token: AnyToken) -> Bool {
//        if let t: TokenType = token as? TokenType {
//            return accepts(token: t)
//        }
//
//        return false
//    }
//
//    public func shouldForward(token: AnyToken) -> Bool {
//        if let t: TokenType = token as? TokenType {
//            return shouldForward(token: t)
//        }
//
//        return false
//    }
//
//    public func canSwap(with token: AnyToken) -> Bool {
//        if let t: TokenType = token as? TokenType {
//            return canSwap(with: t)
//        }
//
//        return false
//    }
//
//    public func swap(with token: AnyToken) -> AnyToken? {
//        if let t: TokenType = token as? TokenType {
//            return swap(with: t)
//        }
//
//        return nil
//    }
//
//    public func canInteract(with token: AnyToken) -> Bool {
//        if let t: TokenType = token as? TokenType {
//            return canInteract(with: t)
//        }
//
//        return false
//    }
//
//    public func interact(with token: AnyToken) -> TokenType? {
//        if let t: TokenType = token as? TokenType {
//            return interact(with: t)
//        }
//
//        return nil
//    }
//
//    public func canPlace(token: AnyToken) -> Bool {
//        if let t: TokenType = token as? TokenType {
//            return canPlace(token: t)
//        }
//
//        return false
//    }
//
//    public func replace(token: AnyToken) {
//        if let t: TokenType = token as? TokenType {
//            replace(token: t)
//        }
//    }
//
//    public func place(token: AnyToken) {
//        if let t: TokenType = token as? TokenType {
//            place(token: t)
//        }
//    }
//
//    // MARK: - Internal
//
//    func place(token: TokenType, _ storageHandler: (TokenType) -> Void) {
//        guard accepts(token: token) else {
//            return
//        }
//
//        token.move(toParent: self)
//        storageHandler(token)
//
//        arrange()
//    }
//}
