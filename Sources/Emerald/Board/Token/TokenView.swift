//
//  TokenView.swift
//  Emerald
//
//  Created by Cristian Diaz on 10.7.2022.
//

import Foundation
import SwiftUI

public struct TokenView<Model: Token, Content: View>: View {
    
    @ObservedObject private(set) var token: Model
    
    @GestureState private var isDragging = false
    @State private var dragOffset: CGSize = .zero
    @State private var sortingOffset = 0
    
    public init(
        token: Model,
        @ViewBuilder content contentBuilder: () -> Content
    ) {
        self.token = token
        content = contentBuilder()
        
        print(token)
    }
    
    public var body: some View {
        content
            .id(token.id)
            .zIndex(token.sortingIndex + sortingOffset)
            .offset(dragOffset)
            .animation(.easeOut(duration: 0.1), value: dragOffset)
            .allowsHitTesting(!token.isLocked)
            .gesture(drag)
            .onChange(of: isDragging) {
                if $0 {
                    token.onPicked?()
                }
            }
    }
    
    // MARK: - Private
    
    private let content: Content
    
    private var drag: some Gesture {
        DragGesture(minimumDistance: 0).onChanged {
            dragOffset = $0.translation
            sortingOffset = 1000
        }.onEnded {
            token.onDropped?($0.translation)
            dragOffset = .zero
            sortingOffset = 0
        }.updating($isDragging) { _, state, _ in
            state = true
        }
    }
}
