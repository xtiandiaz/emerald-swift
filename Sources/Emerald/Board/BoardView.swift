//
//  BoardView.swift
//  Emerald
//
//  Created by Cristian Diaz on 10.7.2022.
//

import Beryllium
import Foundation
import SwiftUI

public struct BoardView<
    TokenModel: Token,
    SpaceModel: Space<TokenModel>,
    Model: Board<TokenModel, SpaceModel>,
    Content: View
> : View {
    
    public typealias ContentBuilder = ([SpaceModel]) -> Content
    
    @ObservedObject public private(set) var board: Model
    
    @State private var spaceAnchors: [AnchorPreferenceValue] = []
    
    public init(
        board: Model,
        @ViewBuilder contentBuilder: @escaping ContentBuilder
    ) {
        self.board = board
        self.contentBuilder = contentBuilder
    }
    
    public var body: some View {
        contentBuilder(Array(board.spaces.values))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .resolveLayout(for: board)
    }
    
    // MARK: - Private
    
    private let contentBuilder: ContentBuilder
}
