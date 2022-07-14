//
//  BoardView.swift
//  Emerald
//
//  Created by Cristian Diaz on 10.7.2022.
//

import Beryllium
import Foundation
import SwiftUI

public struct BoardView<Model: Board, Content: View> : View {
    
    public typealias ContentBuilder = ([AnySpace]) -> Content
    
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
        contentBuilder(board.spaces)
            .backgroundPreferenceValue(AnchorPreferenceKey.self) { prefs in
                GeometryReader { proxy -> Color in
                    prefs.compactMap { $0 }.forEach {
                        board.spaceFrames[$0.id] = proxy[$0.anchor]
                    }
                    return Color.clear
                }
            }
    }
    
    // MARK: - Private
    
    private let contentBuilder: ContentBuilder
}
