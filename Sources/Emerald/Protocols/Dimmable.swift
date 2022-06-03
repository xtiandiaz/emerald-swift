//
//  Dimmable.swift
//  Emerald
//
//  Created by Cristian Diaz on 16.5.2022.
//

import Foundation
import SpriteKit

public protocol Dimmable {
    
    func dim(by factor: CGFloat, withMode mode: DimmingMode)
}
