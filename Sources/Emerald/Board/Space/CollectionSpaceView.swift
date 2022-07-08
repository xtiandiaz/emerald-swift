//
//  CollectionSpaceView.swift
//  Emerald
//
//  Created by Cristian Diaz on 7.7.2022.
//

import Beryllium
import Foundation
import SwiftUI

public struct CollectionSpaceView<Model: CollectionSpace, ItemView: View, PlaceholderView: View> : View {
    
    @ObservedObject public private(set) var space: Model
    
    public typealias ItemBuilder = ((index: Int, count: Int, token: Model.Collection.Element)) -> ItemView
    
    public init(
        space: Model,
        @ViewBuilder itemBuilder: @escaping ItemBuilder,
        @ViewBuilder placeholder placeholderBuilder: () -> PlaceholderView
    ) {
        self.space = space
        self.itemBuilder = itemBuilder
        placeholder = placeholderBuilder()
    }
    
    public var body: some View {
        ZStack {
            placeholder
            
            ForEach(Array(zip(space.collection.indices, space.collection)), id: \.0) { index, token in
                itemBuilder((index, space.collection.count, token))
            }
        }
    }
    
    // MARK: - Private
    
    private let placeholder: PlaceholderView
    private let itemBuilder: ItemBuilder
}

