//
//  Board.swift
//  Emerald
//
//  Created by Cristian Diaz on 6.7.2022.
//

import Beryllium
import Combine
import Foundation
import SwiftUI

open class Board: Identifiable, ObservableObject {
    
    public enum UserInteractionMode {
        case drag, swipe
    }
    
    @Published public private(set) var spaces = [AnySpace]()
    
    public let id = UUID()
    public var name: String?
    
    public func deal(_ token: Token, at localPosition: CGPoint, from anchor: Anchor = .top) {
        if let space = firstSpace(containing: localPosition) {
            space.place(token: token.configure {
                $0.placementOffset = space.frame.center.offset(to: anchor.uiPoint(in: frame))
            })
        }
    }
    
    public init(spaces: [AnySpace]) {
        addSpaces(spaces)
    }
    
    public func addSpaces(_ spaces: [AnySpace]) {
        spaces.forEach {
            addSpace($0)
        }
    }
    
    public func addSpace(_ space: AnySpace) {
        spaces.append(space.configure {
            $0.onPicked = { [unowned self, unowned space] in
                handlePick(of: $0, from: space)
            }
            $0.onDropped = { [unowned self, unowned space] token, offset in
                handleDrop(of: token, from: space, withOffset: offset)
            }
            $0.onPushed = { [unowned self, unowned space] token, direction, offset in
                handlePush(of: token, from: space, toward: direction, withOffset: offset)
            }
        })
    }
    
    open func nextSpace(for token: Token, from space: AnySpace, toward direction: Direction) -> AnySpace? {
        nil
    }
    
    // MARK: - Internal
    
    var frame: CGRect = .zero
    
    func setSpacesHighlighted(_ highlighted: Bool) {
        setSpacesHighlighted(highlighted) { _ in true }
    }
    
    func setSpacesHighlighted(_ highlighted: Bool, where predicate: (AnySpace) -> Bool) {
        spaces.forEach {
            $0.isHighlighted = highlighted && predicate($0)
        }
    }
    
    func updateFrame(_ frame: CGRect, forId id: UUID) {
        if id == self.id {
            self.frame = frame
        } else if let space = (spaces.first { $0.id == id }) {
            space.frame = frame
        } else {
            assertionFailure("Missing Space (\(id)) to set the frame for")
        }
    }
    
    // MARK: - Private
    
    private var subscriptions = Set<AnyCancellable>()
    
    private func handlePick(of token: Token, from space: AnySpace) {
        space.isSelected = true
        
        setSpacesHighlighted(true) {
            $0.id != space.id
        }
    }
    
    private func handleDrop(of token: Token, from origin: AnySpace, withOffset offset: CGSize) {
        handleDrop(of: token, from: origin, at: origin.frame.center.offset(by: offset))
    }
    
    private func handleDrop(of token: Token, from origin: AnySpace, at positionInBoard: CGPoint) {
        handleDrop(
            of: token,
            from: origin,
            at: positionInBoard,
            to: firstSpace(containing: positionInBoard)
        )
    }
    
    private func handleDrop(
        of token: Token,
        from origin: AnySpace,
        at positionInBoard: CGPoint,
        to destination: AnySpace?
    ) {
        defer {
            origin.isSelected = false
            setSpacesHighlighted(false)
        }
        
        guard
            let destination = destination,
            destination != origin,
            destination.canPlace(token: token),
            let token = origin.remove(token: token)
        else {
            return
        }
        
        destination.place(token: token.configure {
            $0.placementOffset = destination.frame.center.offset(to: positionInBoard)
        })
    }
    
    private func handlePush(
        of token: Token,
        from origin: AnySpace,
        toward direction: Direction,
        withOffset offset: CGSize
    ) {
        if let destination = nextSpace(for: token, from: origin, toward: direction) {
            handleDrop(
                of: token,
                from: origin,
                at: origin.frame.center.offset(by: offset),
                to: destination
            )
        } else {
            handleDrop(of: token, from: origin, withOffset: offset)
        }
    }
    
    private func space(forToken token: Token, at localPosition: CGPoint) -> AnySpace? {
        if
            let space = firstSpace(containing: localPosition),
            space.canPlace(token: token)
        {
            return space
        }
        
        return nil
    }
    
    private func firstSpace(containing localPoint: CGPoint) -> AnySpace? {
        if let space = (spaces.first { $0.frame.contains(localPoint) }) {
            return space
        }
        
        return nil
    }
}
