//
//  SpaceLayout.swift
//  Emerald
//
//  Created by Cristian Diaz on 12.7.2022.
//

import Foundation
import SwiftUI

public class SpaceLayout<T: Token>: ObservableObject {
    
    public struct TokenLayoutInfo {
        
        public let index: Int
        public let count: Int
    }
    
    public typealias TokenArrangementOffsetCalculator = (TokenLayoutInfo) -> CGSize
    public typealias RotationCalculator = (TokenLayoutInfo) -> Angle
    
    public init(
        tokenArrangementOffset: @escaping TokenArrangementOffsetCalculator,
        rotation: RotationCalculator? = nil
    ) {
        tokenArrangementOffsetCalculator = tokenArrangementOffset
        rotationCalculator = rotation
    }
    
    // MARK: - Internal
    
    func arrangementOffset(forIndex index: Int, in count: Int) -> CGSize {
        tokenArrangementOffsetCalculator(.init(index: index, count: count))
    }
    
    func rotation(forIndex index: Int, in count: Int) -> Angle {
        rotationCalculator?(.init(index: index, count: count)) ?? .zero
    }
    
    // MARK: - Private
    
    private let tokenArrangementOffsetCalculator: TokenArrangementOffsetCalculator
    private let rotationCalculator: RotationCalculator?
}

