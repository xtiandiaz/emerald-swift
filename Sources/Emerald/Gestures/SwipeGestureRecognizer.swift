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
    
    public var onSwipe: ((Position, Direction) -> Void)?
    
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
        
        let magnitude = startInfo.position.distance(to: info.position)
        
        guard magnitude >= magnitudeThreshold else {
            return
        }
        
        if let direction = startInfo.position.direction(toward: info.position) {
            onSwipe?(startInfo.position, direction)
        }
    }
    
    // MARK: - Private
    
    private var startInfo: TouchInfo?
}
