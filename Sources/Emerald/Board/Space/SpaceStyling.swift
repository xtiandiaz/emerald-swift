//
//  SpaceStyling.swift
//  Emerald
//
//  Created by Cristian Diaz on 12.7.2022.
//

import Foundation
import SwiftUI

public struct SpaceStyling<T: Token> {
    
    public struct TokenStylingInfo {
        
        public let layout: TokenLayout
        public let count: Int
    }
    
    public typealias TokenBrightnessCalculator = (TokenStylingInfo) -> Double
    
    public init(
        tokenBrightness: @escaping TokenBrightnessCalculator
    ) {
        tokenBrightnessCalculator = tokenBrightness
    }
    
    // MARK: - Internal
    
    func brightness(forToken token: T, in count: Int) -> Double {
        tokenBrightnessCalculator(.init(layout: token.layout, count: count))
    }
    
    // MARK: - Private
    
    private let tokenBrightnessCalculator: TokenBrightnessCalculator
}
