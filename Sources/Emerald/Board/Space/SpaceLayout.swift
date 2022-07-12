//
//  SpaceLayout.swift
//  Emerald
//
//  Created by Cristian Diaz on 12.7.2022.
//

import Foundation
import SwiftUI

public struct SpaceLayout<T: Token> {
    
    public struct TokenLayoutInfo {
        
        public let index: Int
        public let count: Int
    }
    
    public typealias TokenArrangementOffsetCalculator = (TokenLayoutInfo) -> CGSize
    
    public init(
        tokenArrangementOffset: @escaping TokenArrangementOffsetCalculator
    ) {
        tokenArrangementOffsetCalculator = tokenArrangementOffset
    }
    
    // MARK: - Internal
    
    func arrangementOffset(forIndex index: Int, in count: Int) -> CGSize {
        tokenArrangementOffsetCalculator(.init(index: index, count: count))
    }
    
    // MARK: - Private
    
    private let tokenArrangementOffsetCalculator: TokenArrangementOffsetCalculator
}

