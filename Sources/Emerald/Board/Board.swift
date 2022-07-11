//
//  Board.swift
//  Emerald
//
//  Created by Cristian Diaz on 6.7.2022.
//

import Combine
import Foundation
import SwiftUI

open class Board<TokenModel: Token, SpaceModel: Space<TokenModel>>: Identifiable, ObservableObject {
    
    @Published public private(set) var spaces = [SpaceModel]()
    
    public init(spaces: [SpaceModel]) {
        self.spaces = spaces
        
        spaces.forEach { space in
            space.onPicked = { [unowned self] in
                handlePick(of: $0, in: space)
            }
            space.onDropped = { [unowned self] in
                handleDrop(of: $0, in: space)
            }
        }
        
        Publishers.MergeMany(spaces.map { $0.objectWillChange })
            .sink { [unowned self] _ in
                objectWillChange.send()
            }
            .store(in: &subscriptions)
    }
    
    // MARK: - Internal
    
    func setSpacesHighlighted(_ highlighted: Bool) {
        setSpacesHighlighted(highlighted) { _ in true }
    }
    
    func setSpacesHighlighted(_ highlighted: Bool, where predicate: (SpaceModel) -> Bool) {
        spaces.forEach {
            $0.isHighlighted = highlighted && predicate($0)
        }
    }
    
    // MARK: - Private
    
    private var subscriptions = Set<AnyCancellable>()
    
    private func handlePick(of token: TokenModel, in space: SpaceModel) {
        space.sortingIndex = spaces.count + 1
        
        setSpacesHighlighted(true) {
            $0.id != space.id
        }
    }
    
    private func handleDrop(of token: TokenModel, in space: SpaceModel) {
        space.sortingIndex = 0
        
        setSpacesHighlighted(false)
    }
}
