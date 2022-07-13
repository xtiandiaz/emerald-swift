//
//  SpaceGroup.swift
//  Emerald
//
//  Created by Cristian Diaz on 12.7.2022.
//

import Combine
import Foundation
import SwiftUI

class SpaceGroup<T: Token, U: Space<T>>: ObservableObject {
    
    @Published private(set) var zIndex = 0
    
    init(spaces: [U]) {
        subscription = Publishers.MergeMany(spaces.map { $0.$isSelected })
            .removeDuplicates()
            .map { $0 ? .max : 0 }
            .assign(to: \.zIndex, on: self)
    }
    
    // MARK: - Private
    
    private var subscription: AnyCancellable?
}
