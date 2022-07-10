//
//  Board.swift
//  Emerald
//
//  Created by Cristian Diaz on 6.7.2022.
//

import Combine
import Foundation
import SwiftUI

open class Board<T: Space>: Identifiable, ObservableObject {
    
    @Published public private(set) var spaces = [T]()
    
    public init(spaces: [T]) {
        self.spaces = spaces
        
        Publishers.MergeMany(spaces.map { $0.objectWillChange })
            .sink { [unowned self] _ in
                objectWillChange.send()
            }
            .store(in: &subscriptions)
    }
    
    public func setSpacesHighlighted(_ highlighted: Bool, for token: T.TokenModel?) {
        spaces.forEach {
            $0.isHighlighted = highlighted
        }
    }
    
    // MARK: - Private
    
    private var subscriptions = Set<AnyCancellable>()
}
