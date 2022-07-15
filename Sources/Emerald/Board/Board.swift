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
    
    @Published public private(set) var spaces = [AnySpace]()
    
    public let id = UUID()
    public var name: String?
    
    public func dropToken(_ token: Token, at localPosition: CGPoint) {
        if let space = firstSpace(containing: localPosition) {
            space.place(token: token.configure {
                $0.dragOffset = space.frame.center.offset(to: Anchor.top.uiPoint(in: frame))
            })
        }
    }
    
    public init(spaces: [AnySpace]) {
        self.spaces = spaces
        
        spaces.forEach { space in
            space.onPicked = { [unowned self] in
                handlePick(of: $0, from: space)
            }
            space.onDropped = { [unowned self] token, offset in
                handleDrop(of: token, from: space, withOffset: offset)
            }
        }
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
            print(frame)
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
    
    private func handleDrop(of token: Token, from space: AnySpace, withOffset offset: CGSize) {
        defer {
            space.isSelected = false
            setSpacesHighlighted(false)
        }
        
        let dropPosition = space.frame.center.offset(by: offset)
        
        guard
            let destination = firstSpace(containing: dropPosition),
            destination.canPlace(token: token),
            let token = space.remove(token: token)
        else {
            return
        }
        
        destination.place(token: token.configure {
            $0.dragOffset = destination.frame.center.offset(to: dropPosition)
        })
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
