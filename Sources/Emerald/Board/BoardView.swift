//
//  BoardView.swift
//  Emerald
//
//  Created by Cristian Diaz on 10.7.2022.
//

import Foundation
import SwiftUI

public struct BoardView<SpaceModel: Space, Model: Board<SpaceModel>, Content: View>: View {
    
    @ObservedObject public private(set) var board: Model
    
    public typealias ContentBuilder = ([SpaceModel]) -> Content
    
    public init(
        board: Model,
        @ViewBuilder contentBuilder: @escaping ContentBuilder
    ) {
        self.board = board
        self.contentBuilder = contentBuilder
    }
    
    public var body: some View {
        contentBuilder(board.spaces)
    }
    
    // MARK: - Private
    
    private let contentBuilder: ContentBuilder
}
