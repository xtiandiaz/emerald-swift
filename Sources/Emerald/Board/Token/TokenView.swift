//
//  TokenView.swift
//  Emerald
//
//  Created by Cristian Diaz on 10.7.2022.
//

import Beryllium
import Foundation
import SwiftUI

public struct TokenView<Model: Token, Content: View>: View {
    
    @ObservedObject private var token: Model
    
    @StateObject private var dragMonitor = DragAndDropMonitor()
    
    @State private var placementOffset: CGSize
    @State private var zIndexOffset: Double = 0
    
    public init(
        token: Model,
        @ViewBuilder content contentBuilder: () -> Content
    ) {
        self.token = token
        content = contentBuilder()
        
        _placementOffset = .init(initialValue: token.placementOffset)
    }
    
    public var body: some View {
        content
            .id(token.id)
            .zIndex(Double(token.layout.zIndex) + zIndexOffset)
            .rotationEffect(token.layout.rotation)
            .brightness(token.styling.brightness)
            .offset(placementOffset + token.layout.offset + dragMonitor.dragOffset)
            .allowsHitTesting(!token.isLocked)
            .gesture(dragMonitor.gesture())
            .onAppear {
                placementOffset = .zero
                configureDragMonitor()
            }
            .animation(animation, value: token.layout.rotation)
            .animation(animation, value: token.layout.offset)
            .animation(animation, value: placementOffset)
            .animation(animation, value: dragMonitor.dragOffset)
    }
    
    // MARK: - Private
    
    private let content: Content
    
    private var animation: Animation {
        .easeOut(duration: 0.1)
    }
    
    private func configureDragMonitor() {
        dragMonitor.configure {
            $0.onPicked = { [unowned token] in
                token.onPicked?()
                zIndexOffset = 1000
            }
            $0.onDropped = { [unowned token] in
                token.onDropped?($0)
                zIndexOffset = 0
            }
            $0.onSwiped = { [unowned token] in
                token.onPushed?($0, $1)
            }
        }
    }
}
