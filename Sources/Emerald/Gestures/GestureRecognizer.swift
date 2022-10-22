//
//  GestureRecognizer.swift
//  Emerald
//
//  Created by Cristian Diaz on 22.10.2022.
//

import Beryllium
import Foundation
import SpriteKit

public protocol GestureRecognizer: Configurable {
    
    func beginWithTouchInfo(_ info: TouchInfo)
    func updateWithTouchInfo(_ info: TouchInfo)
    func endWithTouchInfo(_ info: TouchInfo)
}

extension GestureRecognizer {
    
    public func updateWithTouchInfo(_ info: TouchInfo) {
        // No-op
    }
    
    public func beginWithTouches(_ touches: Set<UITouch>, forNode node: Node) {
        if let touch = touches.first {
            beginWithTouchInfo(touch.info(forNode: node))
        }
    }
    
    public func endWithTouches(_ touches: Set<UITouch>, forNode node: Node) {
        if let touch = touches.first {
            endWithTouchInfo(touch.info(forNode: node))
        }
    }
}
