//
//  CollectionSpaceView.swift
//  Emerald
//
//  Created by Cristian Diaz on 7.7.2022.
//

import Beryllium
import Foundation
import SwiftUI

public struct CollectionSpaceView<
    Collection: TokenCollection,
    Model: CollectionSpace<Collection>,
    Item: View,
    Placeholder: View,
    Highlight: View
> : View {
    
    @ObservedObject public private(set) var space: Model
    
    public typealias ItemBuilder = (Collection.Element) -> Item
    
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
            ForEach(space.collection) {
                itemBuilder($0)
            }
        } placeholder: {
            placeholder
        } highlight: {
            highlight
        }
    }
    
    // MARK: - Private
    
    private let itemBuilder: ItemBuilder
    private let placeholder: Placeholder
    private let highlight: Highlight
}
