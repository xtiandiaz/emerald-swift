//
//  UITouchExtensions.swift
//  Emerald
//
//  Created by Cristian Diaz on 9.5.2022.
//

import Foundation
import SpriteKit

public struct TouchInfo {
    
    public let location: CGPoint
    public let timestamp: TimeInterval
    public let phase: UITouch.Phase
}

extension UITouch {
    
    public func info(forNode node: SKNode) -> TouchInfo {
        TouchInfo(location: location(in: node), timestamp: timestamp, phase: phase)
    }
}
