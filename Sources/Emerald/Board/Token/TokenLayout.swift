//
//  TokenLayout.swift
//  Emerald
//
//  Created by Cristian Diaz on 12.7.2022.
//

import Foundation
import SwiftUI

public struct TokenLayout: Equatable {
    
    public let index: Int
    public let zIndex: Int
    public let arrangementOffset: CGSize
    
    // MARK: - Internal
    
    static let `default` = TokenLayout(index: 0, zIndex: 0, arrangementOffset: .zero)
}
