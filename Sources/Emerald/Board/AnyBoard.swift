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
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard
            let touch = touches.first,
            let space = space(at: touch.location(in: self)),
            !space.isLocked,
            let token = space.takeAny(at: touch.location(in: space)),
            !token.isLocked
        else {
            return
        }
        
        pick = Pick(token: token, offset: touch.location(in: space), space: space)
        
        with(token) {
            $0.move(toParent: self)
            $0.zPosition = 100
            $0.setSelected(true)
        }
        
        setSpacesHighlighted(forToken: token, at: touch.location(in: self))
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        defer {
            pick?.token.setSelected(false)
            pick = nil
            
            setSpacesHighlighted(false)
        }
        
        guard let pick = pick else {
            return
        }
        
        guard
            let touch = touches.first,
            let destination = destination(forToken: pick.token, at: touch.location(in: self)),
            destination.space != pick.space
        else {
            pick.space.restoreAny(token: pick.token)
            return
        }
        
        let positionInDestination = touch.location(in: destination.space)
        
        if destination.space.canInteractWithAny(token: pick.token, at: positionInDestination) {
            destination.space.interactWithAny(token: pick.token, at: positionInDestination)
            
            if !pick.token.isInvalidated {
                pick.space.placeAny(token: pick.token)
            } else {
                disposer.disposeOf(token: pick.token)
            }
            
            purge(space: destination.space)
        } else if
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
    
    // MARK: - Internal
    
    typealias Pick = (token: AnyToken, offset: CGPoint, space: AnySpace)
    
    private(set) var pick: Pick?
    private(set) var bridgedBoards = [Weak<AnyBoard>]()
    
    // MARK: - Private
    
    private let _frame: CGRect
    private let disposer = TokenDisposer()
    
    private var spaces = [AnySpace]()
}

extension AnyBoard {
    
    public var isEmpty: Bool {
        spaces.allSatisfy { $0.isEmpty }
    }
    
    public func space(at location: CGPoint) -> AnySpace? {
        spaces.first { $0.contains(location) }
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
    
    func setSpacesHighlighted(forToken token: AnyToken, at boardPosition: CGPoint) {
        setSpacesHighlighted {
            $0.acceptsAny(token: token, at: convert(boardPosition, to: $0))
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
