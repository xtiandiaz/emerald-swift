//
//  FlatTokenView.swift
//  Emerald
//
//  Created by Cristian Diaz on 8.7.2022.
//

import Foundation
import SwiftUI

public struct FlatTokenView<Model: FlatToken, FrontView: View, BackView: View>: View {
    
    @ObservedObject public private(set) var token: Model
    
    public init(
        token: Model,
        @ViewBuilder front frontBuilder: (Model.FaceType) -> FrontView,
        @ViewBuilder back backBuilder: (Model.FaceType?) -> BackView
    ) {
        self.token = token
        front = frontBuilder(token.front)
        back = backBuilder(token.back)
    }
    
    public var body: some View {
        TokenView(token: token) {
            ZStack {
                front
                    .rotation3DEffect(.degrees(token.side == .front ? 0 : 90), axis: (x: 0, y: 1, z: 0))
                    .animation(
                        .easeInOut(duration: 0.1).delay(token.side == .front ? 0.1 : 0),
                        value: token.side
                    )
                
                back
                    .rotation3DEffect(.degrees(token.side == .back ? 0 : -90), axis: (x: 0, y: 1, z: 0))
                    .animation(
                        .easeInOut(duration: 0.1).delay(token.side == .back ? 0.1 : 0),
                        value: token.side
                    )
            }
        }
    }
    
    // MARK: - Private
    
    private let front: FrontView
    private let back: BackView
}
