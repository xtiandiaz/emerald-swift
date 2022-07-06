//
//  Board.swift
//  Emerald
//
//  Created by Cristian Diaz on 6.7.2022.
//

import Foundation
import SwiftUI

public protocol Board {
    
    associatedtype SpaceModel: Space
    
    var spaces: [SpaceModel] { get }
}

public protocol BoardView: View {
    
    associatedtype Model: Board
    
    var board: Model { get }
}
