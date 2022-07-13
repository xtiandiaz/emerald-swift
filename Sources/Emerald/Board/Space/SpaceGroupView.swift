//
//  SpaceGroupView.swift
//  Emerald
//
//  Created by Cristian Diaz on 12.7.2022.
//

import Combine
import Foundation
import SwiftUI

public struct SpaceGroupView<
    TokenModel: Token,
    SpaceModel: Space<TokenModel>,
    Content: View
> : View {
    
    @ObservedObject private var group: SpaceGroup<TokenModel, SpaceModel>
    
    public init(
        spaces: [SpaceModel],
        @ViewBuilder content contentBuilder: ([SpaceModel]) -> Content
    ) {
        group = .init(spaces: spaces)
        content = contentBuilder(spaces)
    }
    
    public var body: some View {
        content
            .zIndex(group.zIndex)
    }
    
    // MARK: - Private
    
    private let content: Content
}
