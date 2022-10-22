//
//  SwipeGestureRecognizer.swift
//  Emerald
//
//  Created by Cristian Diaz on 22.10.2022.
//

import Beryllium
import Foundation
import SpriteKit

public class SwipeGestureRecognizer: GestureRecognizer {
    
    public var onSwipe: ((Direction) -> Void)?
    
    public var timeout: TimeInterval = 0.35
    public var magnitudeThreshold: CGFloat = 20
    
    public init() {
    }
    
    public func beginWithTouchInfo(_ info: TouchInfo) {
        startInfo = info
    }
    
    public func endWithTouchInfo(_ info: TouchInfo) {
        guard let startInfo else {
            return
        }
        
        defer {
            self.startInfo = nil
        }
        
        let magnitude = startInfo.location.distance(to: info.location)
        
        guard magnitude >= magnitudeThreshold else {
            return
        }
        
        if let direction = startInfo.location.direction(toward: info.location) {
            onSwipe?(direction)
        }
    }
    
    // MARK: - Private
    
    private var startInfo: TouchInfo?
}
