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
    
    open func forward(token: AnyToken) throws {
        fatalError("Not implemented")
    }
    
    // MARK: - Public
    
    public enum Error: Swift.Error {
        case unableToForwardToken(AnyToken, at: Board)
    }

    public var isLocked: Bool {
        get { !isUserInteractionEnabled }
        set { isUserInteractionEnabled = !newValue }
    }

    public var uponMessage: AnyPublisher<BoardMessage, Never> {
        broadcaster.eraseToAnyPublisher()
    }
    
    public override var frame: CGRect {
        _frame
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
            !space.isLocked,
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
        
        setSpacesHighlighted(forToken: token)
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
        if destination.space.shouldForward(token: token) {
            do {
                try destination.board.forward(token: token)
            } catch {
                print(error)
                disposeOf(token: token)
            }
            
            return nil
        }
        
        defer {
            purgeSpace(destination.space)
        }
        
        if destination.space.canSwap(with: token), let swap = destination.space.swap(with: token) {
            return swap
        } else if destination.space.canMutate(with: token) {
            destination.space.mutate(with: token)
            return token
        } else if destination.space.canPlace(token: token) {
            destination.space.place(token: token)
        } else {
            return token
        }
        
        return nil
    }
    
    func setSpacesHighlighted(_ highlighted: Bool) {
        setSpacesHighlighted { _ in highlighted }
    }
    
    func setSpacesHighlighted(forToken token: AnyToken) {
        setSpacesHighlighted {
            $0.shouldHighlight(forToken: token)
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
    
    public var isDirty: Bool {
        false
//        spaces.firstIndex { $0.isDirty } != nil
    }
    
    public func bridge(_ other: Board) {
        if other != self, !bridgedBoards.contains(other) {
            bridgedBoards.append(Weak(other))
            other.bridge(self)
        }
    }
    
    public func arrange() {
        spaces.forEach {
            $0.arrange()
        }
    }
    
    public func space(at location: CGPoint) -> AnySpace? {
        spaces.first { $0.contains(location) }
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
