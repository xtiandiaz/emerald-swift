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
    
    public func dropToken(_ token: Token, at localPosition: CGPoint) {
        if let space = firstSpace(containing: localPosition) {
            space.place(token: token)
        }
    }
    
    public init(spaces: [AnySpace]) {
        self.spaces = spaces
        
        spaceIndex = .init(uniqueKeysWithValues: spaces.map { ($0.id, $0) })
        
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
    
    var spaceFrames = [UUID: CGRect]()
    
    func setSpacesHighlighted(_ highlighted: Bool) {
        setSpacesHighlighted(highlighted) { _ in true }
    }
    
    func setSpacesHighlighted(_ highlighted: Bool, where predicate: (AnySpace) -> Bool) {
        spaces.forEach {
            $0.isHighlighted = highlighted && predicate($0)
        }
    }
    
    // MARK: - Private
    
    private let spaceIndex: [UUID: AnySpace]
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
        
        guard
            let dropPosition = spaceFrames[space.id]?.center.offset(by: offset),
            let destination = firstSpace(containing: dropPosition),
            let destinationRect = spaceFrames[destination.id],
            let token = space.remove(token: token)
        else {
            return
        }
        
        destination.place(token: token.configure {
            $0.dragOffset = destinationRect.center.offset(to: dropPosition)
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
        if let id = (spaceFrames.first { $0.value.contains(localPoint) })?.key {
            return spaceIndex[id]
        }
        
        return nil
    }
}
