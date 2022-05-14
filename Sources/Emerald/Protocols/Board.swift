//
//  Board.swift
//  Emerald
//
//  Created by Cristian Diaz on 14.5.2022.
//

import Foundation

public protocol Board: Node {
    
    var spaces: [Space] { get }
    
    var isLocked: Bool { get set }
    
    func addSpace(_ space: Space)
}

extension Board {
    
    func contains(space: Space) -> Bool {
        spaces.firstIndex { space == $0 } != nil
    }
}
