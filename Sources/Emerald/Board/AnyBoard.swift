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
    
    // MARK: - Public
    
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
            let token = space.takeAny(at: touch.location(in: space))
        else {
            return
        }
        
        pick = Pick(token: token, offset: touch.location(in: space), space: space)
        
        with(token) {
            $0.move(toParent: self)
            $0.zPosition = 100
        }
        
        setSpacesHighlighted(forToken: token, at: touch.location(in: self))
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        defer {
            pick = nil
            setSpacesHighlighted(false)
        }
        
        guard let pick = pick, let touch = touches.first else {
            return
        }
        
        guard let destination = destination(forToken: pick.token, at: touch.location(in: self)) else {
            pick.space.placeAny(token: pick.token)
            return
        }
        
        let positionInDestination = touch.location(in: destination)
        
        if destination.canInteractWithAny(token: pick.token, at: positionInDestination) {
            destination.interactWithAny(token: pick.token, at: positionInDestination)
            
            if !pick.token.isInvalidated {
                pick.space.placeAny(token: pick.token)
            } else {
                disposer.disposeOf(token: pick.token)
            }
            
            purge(space: destination)
        } else if
            destination.canSwapWithAny(token: pick.token, at: positionInDestination),
            let swap = destination.takeAny(at: positionInDestination)
        {
            pick.space.placeAny(token: swap)
            destination.placeAny(token: pick.token)
        } else if destination.canPlaceAny(token: pick.token) {
            destination.placeAny(token: pick.token)
        }
        
        pick.space.arrange()
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
    
    public func space(at location: CGPoint) -> AnySpace? {
        spaces.first { $0.contains(location) }
    }
    
    // MARK: - Internal
    
    func destination(forToken token: AnyToken, at localPosition: CGPoint) -> AnySpace? {
        if let space = space(forToken: token, at: localPosition) {
            return space
        } else if let bridgedSpace = bridgedSpace(forToken: token, at: localPosition) {
            return bridgedSpace
        }
        
        return nil
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

    func bridgedSpace(forToken token: AnyToken, at localPosition: CGPoint) -> AnySpace? {
        bridgedBoards.values
            .lazy
            .compactMap {
                if let space = $0.space(forToken: token, at: $0.convert(localPosition, from: self)) {
                    return space
                }
                
                return nil
            }
            .first
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

//open class Board: Node {
//    
//    open var isLocked = false {
//        didSet {
//            isUserInteractionEnabled = !isLocked
//        }
//    }
//    
//    open func forward(token: AnyToken) throws {
//        fatalError("Not implemented")
//    }
//    
//    // MARK: - Public
//    
//    public enum Error: Swift.Error {
//        case unableToForwardToken(AnyToken, at: Board)
//    }
//
//    public var uponMessage: AnyPublisher<BoardMessage, Never> {
//        broadcaster.eraseToAnyPublisher()
//    }
//    
//    public override var frame: CGRect {
//        _frame
//    }
//
//    public init(frame: CGRect) {
//        _frame = frame
//
//        super.init()
//
//        isUserInteractionEnabled = true
//    }
//
//    public func addSpace(_ space: AnySpace) {
//        spaces.append(space)
//        
//        addChild(space)
//    }
//    
//    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//        
//        guard
//            let touch = touches.first,
//            let space = space(at: touch.location(in: self)),
//            let token = space.take(at: touch.location(in: space))
//        else {
//            return
//        }
//        
//        pick = Pick(token: token, offset: touch.location(in: space), space: space)
//        
//        with(token) {
//            $0.move(toParent: self)
//            $0.zPosition = 100
//            $0.setSelected(true)
//        }
//        
//        setSpacesHighlighted(forToken: token)
//    }
//    
//    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesEnded(touches, with: event)
//        
//        defer {
//            setSpacesHighlighted(false)
//            
//            with(pick) {
//                $0.token.move(toParent: $0.space)
//                $0.token.setSelected(false)
//                purgeSpace($0.space)
//            }
//            
//            self.pick = nil
//        }
//        
//        guard
//            let location = touches.first?.location(in: self),
//            let pick = pick
//        else {
//            return
//        }
//        
//        guard
//            let destination = destination(for: pick.token, at: location),
//            destination.space != pick.space
//        else {
//            return
//        }
//        
////        if let target = destination.space.take(at: location) {
////            pick.token.interact(with: target)
////        } else {
////
////        }
//        
////        guard let returnedToken = play(token: pick.token, at: destination) else {
////            return
////        }
////
////        if returnedToken.isInvalidated {
////            disposeOf(token: returnedToken)
////        } else {
////            pick.space.place(token: returnedToken)
////        }
////
//        purgeSpace(destination.space)
//    }
//    
//    // MARK: - Internal
//    
//    typealias Pick = (token: AnyToken, offset: CGPoint, space: AnySpace)
//    
//    private(set) var pick: Pick?
//    private(set) var spaces = [AnySpace]()
//    private(set) var bridgedBoards = [Weak<Board>]()
//    
//    let broadcaster = MessageBroadcaster<BoardMessage>()
//    
//    func play(token: AnyToken, at destination: TokenDestination) -> AnyToken? {
//        return nil
////        if destination.space.accepts(token: token) {
////            destination.space.place(token: token)
////            return nil
////        } else {
////            return token
////        }
//    }
//    
//    func setSpacesHighlighted(_ highlighted: Bool) {
//        setSpacesHighlighted { _ in highlighted }
//    }
//    
//    func setSpacesHighlighted(forToken token: AnyToken) {
//        setSpacesHighlighted {
//            $0.shouldHighlight(forToken: token)
//        }
//    }
//    
//    func setSpacesHighlighted(where predicate: (AnySpace) -> Bool) {
//        spaces.forEach {
//            $0.setHighlighted(predicate($0))
//        }
//        
//        bridgedBoards.values
//            .flatMap { $0.spaces }
//            .forEach { $0.setHighlighted(predicate($0)) }
//    }
//    
//    func cancelMove() {
//        guard let pick = pick else {
//            return
//        }
//        
//        pick.space.place(token: pick.token)
//        
//        setSpacesHighlighted(false)
//        
//        self.pick = nil
//    }
//
//    // MARK: - Private
//    
//    private let _frame: CGRect
//    private let disposer = TokenDisposer()
//    
//    private lazy var debugNode = SKShapeNode(rect: frame)
//}
//
//extension Board {
//    
//    public func bridge(_ other: Board) {
//        if other != self, !bridgedBoards.contains(other) {
//            bridgedBoards.append(Weak(other))
//            other.bridge(self)
//        }
//    }
//    
//    public func arrange() {
//        spaces.forEach {
//            $0.arrange()
//        }
//    }
//    
//    public func space(at location: CGPoint) -> AnySpace? {
//        spaces.first { $0.contains(location) }
//    }
//    
//    public func setVisible(_ visible: Bool, withColor color: UIColor) {
//        if !visible {
//            debugNode.removeFromParent()
//        } else if debugNode.parent.isNil {
//            addChild(debugNode.configure {
//                $0.fillColor = color
//            })
//        }
//    }
//    
//    // MARK: - Internal
//    
//    struct TokenDestination {
//        
//        let space: AnySpace
//        let board: Board
//    }
//    
//    func destination(for token: AnyToken, at location: CGPoint) -> TokenDestination? {
//        if let inner = space(for: token, at: location) {
//            return TokenDestination(space: inner, board: self)
//        } else if let outer = bridgedSpace(for: token, at: location) {
//            return TokenDestination(space: outer.space, board: outer.board)
//        }
//        
//        return nil
//    }
//    
//    func space(for token: AnyToken, at location: CGPoint) -> AnySpace? {
//        if let space = space(at: location)/*, token.canBeUsedOn(space: space)*/ {
//            return space
//        }
//        
//        return nil
//    }
//    
//    func bridgedSpace(for token: AnyToken, at location: CGPoint) -> (space: AnySpace, board: Board)? {
//        bridgedBoards.values
//            .lazy
//            .compactMap {
//                if let space = $0.space(for: token, at: $0.convert(location, from: self)) {
//                    return (space, $0)
//                }
//                
//                return nil
//            }
//            .first
//    }
//    
//    func purgeSpace(_ space: AnySpace) {
//        space.purge().forEach(disposer.disposeOf)
//    }
//    
//    func disposeOf(token: AnyToken) {
//        disposer.disposeOf(token: token)
//        
//        broadcaster.send(.tokenDisposedOf(token))
//    }
//}
