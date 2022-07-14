//
//  SpaceGrid.swift
//  Emerald
//
//  Created by Cristian Diaz on 14.7.2022.
//

import Beryllium
import Combine
import Foundation
import SwiftUI

private final class Row: ObservableObject {
    
    @Published private(set) var zIndex = 0
    
    init(spaces: [AnySpace]) {
        self.spaces = spaces
        
        subscription = Publishers.MergeMany(spaces.map { $0.$isSelected })
            .removeDuplicates()
            .map { $0 ? .max : 0 }
            .assign(to: \.zIndex, on: self)
    }
    
    // MARK: - Fileprivate
    
    fileprivate var spaces: [AnySpace]
    
    // MARK: - Private
    
    private var subscription: AnyCancellable?
}

public struct SpaceRow<SpaceView: View>: View {
    
    public typealias ItemBuilder = (AnySpace) -> SpaceView
    
    @ObservedObject private var row: Row
    
    public init(
        spaces: [AnySpace],
        spacing: CGFloat = .s,
        @ViewBuilder itemBuilder: @escaping ItemBuilder
    ) {
        row = .init(spaces: spaces)
        self.spacing = spacing
        self.itemBuilder = itemBuilder
    }
    
    public var body: some View {
        HStack(spacing: spacing) {
            ForEach(row.spaces) {
                itemBuilder($0)
            }
        }
        .zIndex(row.zIndex)
    }
    
    // MARK: - Private
    
    private let spacing: CGFloat
    private let itemBuilder: ItemBuilder
}

public struct SpaceGrid<SpaceView: View>: View {
    
    public init(
        spaces: [AnySpace],
        cols: Int,
        spacing: CGSize = CGSize(length: .s),
        @ViewBuilder itemBuilder: @escaping SpaceRow<SpaceView>.ItemBuilder
    ) {
        self.cols = cols
        rows = spaces.count / cols
        self.spacing = spacing
        self.spaces = spaces
        self.itemBuilder = itemBuilder
    }
    
    public var body: some View {
        VStack(spacing: spacing.height) {
            ForEach(0..<rows, id: \.self) { row in
                SpaceRow(
                    spaces: Array(spaces[row * cols..<min(spaces.count, (row + 1) * cols)]),
                    spacing: spacing.width
                ) {
                    itemBuilder($0)
                }
            }
        }
    }
    
    // MARK: - Private
    
    private let spaces: [AnySpace]
    private let cols: Int
    private let rows: Int
    private let spacing: CGSize
    private let itemBuilder: SpaceRow<SpaceView>.ItemBuilder
}