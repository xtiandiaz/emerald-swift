//
//  UISpaceView.swift
//  Emerald
//
//  Created by Cristian Diaz on 7.7.2022.
//

import Beryllium
import Foundation
import SwiftUI

public struct UISpaceView<
    Collection: TokenCollection,
    Model: UISpace<Collection>,
    Item: View,
    Placeholder: View,
    Highlight: View
> : View {
    
    public typealias ItemBuilder = (Collection.Element) -> Item
    
    @ObservedObject private var space: Model
    
    public init(
        space: Model,
        @ViewBuilder itemBuilder: @escaping ItemBuilder,
        @ViewBuilder placeholder placeholderBuilder: () -> Placeholder,
        @ViewBuilder highlight highlightBuilder: () -> Highlight
    ) {
        self.space = space
        self.itemBuilder = itemBuilder
        placeholder = placeholderBuilder()
        highlight = highlightBuilder()
    }
    
    public var body: some View {
        ZStack {
            placeholder
                .zIndex(-1)
            
            ForEach(space.tokens) {
                itemBuilder($0)
            }
            
            if space.isHighlighted {
                highlight
                    .zIndex(space.tokenCount)
            }
        }
        .aspectRatio(space.layout.tokenAspect, contentMode: .fit)
        .anchorPreference(id: space.id, value: .bounds)
        .zIndex(space.isSelected ? .max : 0)
    }
    
    // MARK: - Private
    
    private let itemBuilder: ItemBuilder
    private let placeholder: Placeholder
    private let highlight: Highlight
}
