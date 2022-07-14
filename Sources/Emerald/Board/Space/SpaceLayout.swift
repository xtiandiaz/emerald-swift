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
        tokenAspect: CGSize,
        tokenOffset: @escaping TokenArrangementOffsetCalculator,
        tokenRotation: RotationCalculator? = nil
    ) {
        self.tokenAspect = tokenAspect
        tokenArrangementOffsetCalculator = tokenOffset
        rotationCalculator = tokenRotation
    }
    
    // MARK: - Internal
    
    let tokenAspect: CGSize
    
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

