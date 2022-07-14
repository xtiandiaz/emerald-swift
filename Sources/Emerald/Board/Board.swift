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

struct SpaceFrame {
    
    let id: UUID
    let rect: CGRect
}

open class Board: Identifiable, ObservableObject {
    
    @Published public private(set) var spaces = [UUID: AnySpace]()
    
    public func dropToken(_ token: Token, at localPosition: CGPoint) {
        guard
            let frame = (spaceFrames.values.first { $0.rect.contains(localPosition) }),
            let space = spaces[frame.id]
        else {
            return
        }
        
        space.place(token: token)
    }
    
    public init(spaces: [AnySpace]) {
        self.spaces = .init(uniqueKeysWithValues: spaces.map { ($0.id, $0) })
        
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
    
    func setSpacesHighlighted(_ highlighted: Bool) {
        setSpacesHighlighted(highlighted) { _ in true }
    }
    
    func setSpacesHighlighted(_ highlighted: Bool, where predicate: (AnySpace) -> Bool) {
        spaces.forEach {
            $0.value.isHighlighted = highlighted && predicate($0.value)
        }
    }
    
    // MARK: - Fileprivate
    
    fileprivate var spaceFrames = [UUID: SpaceFrame]()
    
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
        
        guard
            let dropPosition = spaceFrames[space.id]?.rect.center.offset(by: offset),
            let destination = self.space(forToken: token, at: dropPosition),
            let destinationRect = spaceFrames[destination.id]?.rect,
            let token = space.remove(token: token)
        else {
            return
        }
        
        destination.place(token: token.configure {
            $0.dragOffset = destinationRect.center.offset(to: dropPosition)
        })
    }
    
    private func space(forToken token: Token, at localPosition: CGPoint) -> AnySpace? {
        guard
            let id = (spaceFrames.values.first { $0.rect.contains(localPosition) })?.id,
            let space = spaces[id],
            space.canPlace(token: token)
        else {
            return nil
        }
        
        return space
    }
}

extension View {
    
    func resolveLayout(for board: Board) -> some View {
        self.backgroundPreferenceValue(AnchorPreferenceKey.self) { prefs in
            GeometryReader { proxy -> Color in
                prefs.compactMap { $0 }.forEach {
                    board.spaceFrames[$0.id] = SpaceFrame(id: $0.id, rect: proxy[$0.anchor])
                }
                return Color.clear
            }
        }
    }
}

