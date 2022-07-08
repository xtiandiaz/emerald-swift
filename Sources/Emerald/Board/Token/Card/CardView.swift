//
//  CardView.swift
//  Emerald
//
//  Created by Cristian Diaz on 8.7.2022.
//

import Foundation
import SwiftUI

public struct CardView<Model: Card, FrontView: View, BackView: View>: View {
    
    @ObservedObject public private(set) var card: Model
    
    public init(
        card: Model,
        @ViewBuilder front frontBuilder: (Model.FaceType) -> FrontView,
        @ViewBuilder back backBuilder: (Model.FaceType) -> BackView
    ) {
        self.card = card
        front = frontBuilder(card.front)
        back = backBuilder(card.back)
    }
    
    public var body: some View {
        ZStack {
            front
                .rotation3DEffect(.degrees(card.side == .front ? 0 : 90), axis: (x: 0, y: 1, z: 0))
                .animation(
                    .easeInOut(duration: 0.1).delay(card.side == .front ? 0.1 : 0),
                    value: card.side
                )
                .id(card.front.id)
            
            back
                .rotation3DEffect(.degrees(card.side == .back ? 0 : -90), axis: (x: 0, y: 1, z: 0))
                .animation(
                    .easeInOut(duration: 0.1).delay(card.side == .back ? 0.1 : 0),
                    value: card.side
                )
                .id(card.back.id)
        }
    }
    
    // MARK: - Private
    
    private let front: FrontView
    private let back: BackView
}
