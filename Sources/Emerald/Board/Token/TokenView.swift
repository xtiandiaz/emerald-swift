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
    
    public init(
        token: Model,
        @ViewBuilder content contentBuilder: () -> Content
    ) {
        self.token = token
        content = contentBuilder()
    }
    
    public var body: some View {
        content
            .id(token.id)
    }
    
    // MARK: - Private
    
    private let content: Content
}
