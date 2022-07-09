//
//  SpaceView.swift
//  Emerald
//
//  Created by Cristian Diaz on 7.7.2022.
//

import Foundation
import SwiftUI

public struct SpaceView<Content: View, Highlight: View, Placeholder: View> : View {
    
    @Binding public var isHighlighted: Bool
    
    public init(
        isHighlighted: Binding<Bool>,
        @ViewBuilder content contentBuilder: () -> Content,
        @ViewBuilder placeholder placeholderBuilder: () -> Placeholder,
        @ViewBuilder highlight highlightBuilder: () -> Highlight
    ) {
        _isHighlighted = isHighlighted
        content = contentBuilder()
        placeholder = placeholderBuilder()
        highlight = highlightBuilder()
    }
    
    public var body: some View {
        ZStack {
            placeholder
            content
            
            if isHighlighted {
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
