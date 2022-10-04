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
    
    @State private var spaceAnchors: [AnchorPreferenceValue<UUID>] = []
    
    public init(
        board: Model,
        @ViewBuilder contentBuilder: @escaping ContentBuilder
    ) {
        self.board = board
        self.contentBuilder = contentBuilder
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.clear
                    .allowsHitTesting(false)
                    .anchorPreference(id: board.id, value: .bounds)
                
                contentBuilder(board.spaces)
            }
            .onPreferenceChange(AnchorPreferenceKey.self) { prefs in
                prefs.compactMap { $0 }.forEach {
                    board.updateFrame(proxy[$0.anchor], forId: $0.id)
                }
            }
        }
    }
    
    // MARK: - Private
    
    private let contentBuilder: ContentBuilder
}
