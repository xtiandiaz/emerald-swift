//
//  SpaceView.swift
//  Emerald
//
//  Created by Cristian Diaz on 7.7.2022.
//

import Foundation
import SwiftUI

public struct CollectionSpaceStyling {
    
    public let offset: CGSize
    public let effectMultiplier: Double
    
    public init(offset: CGSize, effectMultiplier: Double) {
        self.offset = offset
        self.effectMultiplier = effectMultiplier
    }
}
