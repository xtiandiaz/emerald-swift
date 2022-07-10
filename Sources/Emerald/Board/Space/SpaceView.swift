//
//  SpaceView.swift
//  Emerald
//
//  Created by Cristian Diaz on 7.7.2022.
//

import Foundation
import SwiftUI

public struct SpaceView<Model: Space, Content: View, Highlight: View, Placeholder: View> : View {
    
    @ObservedObject private(set) var space: Model
    
    public init(
        space: Model,
        @ViewBuilder content contentBuilder: () -> Content,
        @ViewBuilder placeholder placeholderBuilder: () -> Placeholder,
        @ViewBuilder highlight highlightBuilder: () -> Highlight
    ) {
        self.space = space
        content = contentBuilder()
        placeholder = placeholderBuilder()
        highlight = highlightBuilder()
    }
    
    public var body: some View {
        ZStack {
            placeholder
            content
            
            if space.isHighlighted {
                highlight
                    .zIndex(.max)
            }
        }
    }
    
    // MARK: - Private
    
    private let content: Content
    private let placeholder: Placeholder
    private let highlight: Highlight
}
