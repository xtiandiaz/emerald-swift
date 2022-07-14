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
    public let offset: CGSize
    public let rotation: Angle
    
    // MARK: - Internal
    
    static let `default` = TokenLayout(
        index: 0,
        zIndex: 0,
        offset: .zero,
        rotation: .zero
    )
}
