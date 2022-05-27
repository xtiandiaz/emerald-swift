//
//  Board.swift
//  Emerald
//
//  Created by Cristian Diaz on 14.5.2022.
//

import Beryllium
import Combine
import Foundation
import SpriteKit

open class Board: Node {

    public private(set) var spaces = [AnySpace]()

    public var isLocked: Bool {
        get { !isUserInteractionEnabled }
        set { isUserInteractionEnabled = !newValue }
    }

    public override var frame: CGRect {
        _frame
    }
    
    public var uponMessage: AnyPublisher<BoardMessage, Never> {
        broadcaster.eraseToAnyPublisher()
    }

    public init(frame: CGRect) {
        _frame = frame

        super.init()

        isLocked = false
    }

    public func addSpace(_ space: AnySpace) {
        spaces.append(space)
        
        addChild(space)
    }
    
    // MARK: - Internal
    
    let broadcaster = MessageBroadcaster<BoardMessage>()
    let disposer = TokenDisposer()
    
    func bridge(_ other: Board) {
        if other != self, !bridgedBoards.contains(other) {
            bridgedBoards.append(Weak(other))
            other.bridge(self)
        }
    }
    
    func play(token: AnyToken, at location: CGPoint, elseReturnTo originalSpace: AnySpace) {
        guard let destination = destination(for: token, at: location) else {
            originalSpace.place(token: token)
            return
        }
        
        if destination.canSwap(with: token), let swap = destination.swap(with: token) {
            originalSpace.place(token: swap)
        } else if destination.canMutate(with: token) {
            destination.mutate(with: token)
            
            if token.isInvalidated {
                disposeOf(token: token)
            } else {
                originalSpace.place(token: token)
            }
        } else if destination.canPlace(token: token) {
            destination.place(token: token)
        }
        
        purgeSpace(originalSpace)
        purgeSpace(destination)
    }
    
    func setSpacesHighlighted(_ highlighted: Bool) {
        setSpacesHighlighted(highlighted) { _ in true }
    }
    
    func setSpacesHighlighted(_ highlighted: Bool, where predicate: (AnySpace) -> Bool) {
        let setHighlighted = { (space: AnySpace) -> Void in
            space.setHighlighted(highlighted && predicate(space))
        }
        
        spaces.forEach(setHighlighted)
        bridgedBoards.values.flatMap { $0.spaces }.forEach(setHighlighted)
    }
    
    func cancelMove() {
        fatalError("Not implemented")
    }

    // MARK: - Private

    private let _frame: CGRect
    
    private var bridgedBoards = [Weak<Board>]()
    
    private lazy var debugNode = SKShapeNode(rect: frame)
}

extension Board {
    
    public func setVisible(_ visible: Bool, withColor color: UIColor) {
        if !visible {
            debugNode.removeFromParent()
        } else if debugNode.parent.isNil {
            addChild(debugNode.configure {
                $0.fillColor = color
            })
        }
    }
    
    // MARK: - Internal
    
    func purgeSpace(_ space: AnySpace) {
        space.purge().forEach(disposer.disposeOf)
        space.arrange()
    }
    
    func disposeOf(token: AnyToken) {
        disposer.disposeOf(token: token)
        
        broadcaster.send(.tokenDisposedOf(token))
    }
    
    func destination(for token: AnyToken, at location: CGPoint) -> AnySpace? {
        if let destination = space(for: token, at: location) {
            return destination
        } else if let bridgedDestination = bridgedSpace(for: token, at: location) {
            return bridgedDestination
        }
        
        return nil
    }
    
    func space(at location: CGPoint) -> AnySpace? {
        spaces.first { $0.contains(location) }
    }
    
    func space(for token: AnyToken, at location: CGPoint) -> AnySpace? {
        if let space = space(at: location), token.canBeUsedOn(space: space) {
            return space
        }
        
        return nil
    }
    
    func bridgedSpace(for token: AnyToken, at location: CGPoint) -> AnySpace? {
        bridgedBoards.values
            .compactMap { $0.space(for: token, at: $0.convert(location, from: self)) }
            .first
    }
}
