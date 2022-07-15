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
    @GestureState private var zIndexOffset = 0
    @State private var dragOffset: CGSize
    
    public init(
        token: Model,
        @ViewBuilder content contentBuilder: () -> Content
    ) {
        self.token = token
        _dragOffset = .init(initialValue: token.dragOffset)
        content = contentBuilder()
        
        print(token, token.dragOffset)
    }
    
    public var body: some View {
        content
            .id(token.id)
            .zIndex(token.layout.zIndex + zIndexOffset)
            .offset(token.layout.offset + dragOffset)
            .rotationEffect(token.layout.rotation)
            .brightness(token.styling.brightness)
            .allowsHitTesting(!token.isLocked)
            .gesture(drag)
            .onChange(of: isDragging) {
                if $0 {
                    token.onPicked?()
                }
            }
            .onAppear {
                dragOffset = .zero
            }
            .animation(.easeOut(duration: 0.1), value: dragOffset)
            .animation(.easeOut(duration: 0.1), value: token.layout.offset)
            .animation(.easeOut(duration: 0.1), value: token.layout.rotation)
    }
    
    // MARK: - Private
    
    private let content: Content
    
    private var drag: some Gesture {
        DragGesture(minimumDistance: 0).onChanged {
            dragOffset = $0.translation
        }.onEnded {
            token.onDropped?($0.translation)
            dragOffset = .zero
        }.updating($isDragging) { _, state, _ in
            state = true
        }.updating($zIndexOffset) { _, state, _ in
            state = 1000
        }
    }
}
