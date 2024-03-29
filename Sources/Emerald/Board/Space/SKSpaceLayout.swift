//
//  SKSpaceLayout.swift
//  Emerald
//
//  Created by Cristian Diaz on 16.5.2022.
//

import Foundation
import SpriteKit

public struct SKCollectionSpaceLayout {
    
    public static let `default` = SKCollectionSpaceLayout(
        offset: CGSize(height: .xl),
        dimmingMode: .darkening
    )
    
    public let offset: CGSize
    public let dimmingMode: DimmingMode
    
    public init(offset: CGSize, dimmingMode: DimmingMode) {
        self.offset = offset
        self.dimmingMode = dimmingMode
    }
}
