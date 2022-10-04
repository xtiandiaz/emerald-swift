//
//  HandSpaceView.swift
//  Emerald
//
//  Created by Cristian Diaz on 13.7.2022.
//

import Beryllium
import Foundation
import SwiftUI

public struct HandSpaceView<
    TokenModel: Token,
    Model: HandSpace<TokenModel>,
    Item: View,
    Placeholder: View,
    Highlight: View
>: View {
    
    public typealias ItemBuilder = (TokenModel) -> Item
    
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
        SpaceView(space: space) {
            itemBuilder($0)
        } placeholder: {
            placeholder
        } highlight: {
            highlight
        }
        .anchorPreference(id: space.id, value: .bounds)
        .onPreferenceChange(AnchorPreferenceKey<UUID>.self) {
            print($0)
        }
    }
    
    // MARK: - Private
    
    private let itemBuilder: ItemBuilder
    private let placeholder: Placeholder
    private let highlight: Highlight
}
