//
//  AnyBoard.swift
//  Emerald
//
//  Created by Cristian Diaz on 14.5.2022.
//

import Beryllium
import Combine
import Foundation
import SpriteKit

open class AnyBoard: Node {
    
    public override var frame: CGRect {
        _frame
    }

    public init(frame: CGRect) {
        _frame = frame

        super.init()

        isUserInteractionEnabled = true
    }
    
    public func add(spaces: [AnySpace]) {
        spaces.forEach(add)
    }
    
    public func add(space: AnySpace) {
        spaces.append(space)
        addChild(space)
    }
    
    public func bridge(_ other: AnyBoard) {
        if other != self, !bridgedBoards.contains(other) {
            bridgedBoards.append(Weak(other))
            other.bridge(self)
        }
    }
    
    // MARK: - Internal
    
    typealias Pick = (token: AnyToken, offset: CGPoint, space: AnySpace)
    
    private(set) var pick: Pick?
    private(set) var bridgedBoards = [Weak<AnyBoard>]()
    
    final func pickAt(location: CGPoint) {
        guard
            let space = space(at: location),
            !space.isLocked,
            let token = space.takeAny(at: space.convert(location, from: self)),
            !token.isLocked
        else {
            return
        }
        
        with(token) {
            $0.move(toParent: self)
            $0.setSelected(true)
            
            setSpacesHighlighted(forToken: $0)
        }
        
        pick = Pick(token: token, offset: space.convert(location, from: self), space: space)
    }
    
    final func dropAt(location: CGPoint) {
        defer {
            pick?.token.setSelected(false)
            pick = nil
            
            setSpacesHighlighted(false)
        }
        
        guard let pick = pick else {
            return
        }
        
        guard
            let destination = destination(forToken: pick.token, at: location),
            destination.space != pick.space
        else {
            pick.space.restoreAny(token: pick.token)
            return
        }
        
        let positionInDestination = destination.space.convert(location, from: self)
        
        if destination.space.canInteractWithAny(token: pick.token, at: positionInDestination) {
            destination.space.interactWithAny(token: pick.token, at: positionInDestination)
            
            purge(space: destination.space)
        }
        
        if
            destination.space.canSwapWithAny(token: pick.token, at: positionInDestination),
            let swap = destination.space.takeAny(at: positionInDestination)
        {
            pick.space.placeAny(token: swap)
            destination.space.placeAny(token: pick.token)
        } else if destination.space.canPlaceAny(token: pick.token) {
            destination.space.placeAny(token: pick.token)
        } else {
            pick.space.restoreAny(token: pick.token)
        }
        
        purge(space: pick.space)
    }
    
    // MARK: - Private
    
    private let _frame: CGRect
    private let disposer = TokenDisposer()
    
    private var spaces = [AnySpace]()
    
    private var debugFrameNode: SKShapeNode?
}

extension AnyBoard {
    
    public var isEmpty: Bool {
        spaces.allSatisfy { $0.isEmpty }
    }
    
    public func space(at location: CGPoint) -> AnySpace? {
        spaces.first { $0.contains(location) }
    }
    
    public func setDebugFrameVisible(
        _ visible: Bool,
        withColor color: UIColor = .cyan.withAlphaComponent(0.5)
    ) {
        with(debugFrameNode ?? SKShapeNode(rect: frame).configure {
            $0.fillColor = color
        }) {
            if visible, $0.parent.isNil {
                addChild($0)
            } else {
                $0.removeFromParent()
            }
                
            self.debugFrameNode = $0
        }
    }
    
    // MARK: - Internal
    
    typealias TokenDestination = (space: AnySpace, board: AnyBoard)
    
    func destination(forToken token: AnyToken, at localPosition: CGPoint) -> TokenDestination? {
        if let space = space(forToken: token, at: localPosition) {
            return (space, self)
        } else if let bridged = bridgedDestination(forToken: token, at: localPosition) {
            return bridged
        }
        
        return nil
    }
    
    func bridgedDestination(forToken token: AnyToken, at localPosition: CGPoint) -> TokenDestination? {
        bridgedBoards.values
            .lazy
            .compactMap {
                if let space = $0.space(forToken: token, at: $0.convert(localPosition, from: self)) {
                    return (space, $0)
                }
                return nil
            }
            .first
    }
    
    func space(forToken token: AnyToken, at localPosition: CGPoint) -> AnySpace? {
        if
            let space = space(at: localPosition),
            space.acceptsAny(token: token, at: convert(localPosition, to: space))
        {
            return space
        }

        return nil
    }
    
    func purge(space: AnySpace) {
        space.purge().forEach(disposer.disposeOf)
    }
    
    func setSpacesHighlighted(_ highlighted: Bool) {
        setSpacesHighlighted { _ in highlighted }
    }
    
    func setSpacesHighlighted(forToken token: AnyToken) {
        setSpacesHighlighted {
            $0.acceptsAny(token: token)
        }
    }
    
    func setSpacesHighlighted(where predicate: (AnySpace) -> Bool) {
        spaces.forEach {
            $0.setHighlighted(predicate($0))
        }
        
        bridgedBoards.values
            .flatMap { $0.spaces }
            .forEach { $0.setHighlighted(predicate($0)) }
    }
}
