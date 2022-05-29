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
    
    open func forward(token: AnyToken) -> Bool {
        fatalError()
    }
    
    // MARK: - Public

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
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard
            let touch = touches.first,
            let space = space(at: touch.location(in: self)),
            let token = space.pickToken(at: touch.location(in: space))
        else {
            return
        }
        
        pick = Pick(token: token, offset: touch.location(in: space), space: space)
        
        with(token) {
            $0.move(toParent: self)
            $0.zPosition = 100
            $0.setSelected(true)
        }
        
        setSpacesHighlighted(true, for: token)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        guard
            let location = touches.first?.location(in: self),
            let pick = pick
        else {
            return
        }
        
        if let returnedToken = play(token: pick.token, at: location) {
            if returnedToken.isInvalidated {
                disposeOf(token: returnedToken)
                pick.space.arrange()
            } else {
                pick.space.place(token: returnedToken)
            }
        } else {
            purgeSpace(pick.space)
        }
        
        pick.token.setSelected(false)
        
        setSpacesHighlighted(false)
        
        bridgedBoards.values.forEach {
            $0.setSpacesHighlighted(false)
        }
        
        self.pick = nil
    }
    
    // MARK: - Internal
    
    typealias Pick = (token: AnyToken, offset: CGPoint, space: AnySpace)
    
    private(set) var pick: Pick?
    private(set) var spaces = [AnySpace]()
    private(set) var bridgedBoards = [Weak<Board>]()
    
    let broadcaster = MessageBroadcaster<BoardMessage>()
    
    func play(token: AnyToken, at location: CGPoint) -> AnyToken? {
        guard let destination = destination(for: token, at: location) else {
            return token
        }
        
        return play(token: token, at: destination)
    }
    
    func play(token: AnyToken, at destination: TokenDestination) -> AnyToken? {
        let space = destination.space
        
        if space.shouldForward(token: token), destination.board.forward(token: token) {
            return nil
        }
        
        defer {
            purgeSpace(space)
        }
        
        if space.canSwap(with: token), let swap = space.swap(with: token) {
            return swap
        } else if space.canMutate(with: token) {
            space.mutate(with: token)
            return token
        } else if space.canPlace(token: token) {
            space.place(token: token)
        } else {
            return token
        }
        
        return nil
    }
    
    func setSpacesHighlighted(_ highlighted: Bool) {
        spaces.forEach {
            $0.setHighlighted(highlighted)
        }
        
        bridgedBoards.values
            .flatMap { $0.spaces }
            .forEach { $0.setHighlighted(highlighted) }
    }
    
    func setSpacesHighlighted(_ highlighted: Bool, for token: AnyToken) {
        spaces.forEach {
            $0.setHighlighted(highlighted, for: token)
        }
        
        bridgedBoards.values
            .flatMap { $0.spaces }
            .forEach { $0.setHighlighted(highlighted, for: token) }
    }
    
    func cancelMove() {
        guard let pick = pick else {
            return
        }
        
        pick.space.place(token: pick.token)
        
        setSpacesHighlighted(false)
        
        self.pick = nil
    }

    // MARK: - Private
    
    private let _frame: CGRect
    private let disposer = TokenDisposer()
    
    private lazy var debugNode = SKShapeNode(rect: frame)
}

extension Board {
    
    public func bridge(_ other: Board) {
        if other != self, !bridgedBoards.contains(other) {
            bridgedBoards.append(Weak(other))
            other.bridge(self)
        }
    }
    
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
    
    struct TokenDestination {
        
        let space: AnySpace
        let board: Board
    }
    
    func destination(for token: AnyToken, at location: CGPoint) -> TokenDestination? {
        if let inner = space(for: token, at: location) {
            return TokenDestination(space: inner, board: self)
        } else if let outer = bridgedSpace(for: token, at: location), let space = outer.space {
            return TokenDestination(space: space, board: outer.board)
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
    
    func bridgedSpace(for token: AnyToken, at location: CGPoint) -> (space: AnySpace?, board: Board)? {
        bridgedBoards.values
            .lazy
            .compactMap { ($0.space(for: token, at: $0.convert(location, from: self)), $0) }
            .first
    }
    
    func purgeSpace(_ space: AnySpace) {
        space.purge().forEach(disposer.disposeOf)
        space.arrange()
    }
    
    func disposeOf(token: AnyToken) {
        disposer.disposeOf(token: token)
        
        broadcaster.send(.tokenDisposedOf(token))
    }
}
