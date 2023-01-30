//
//  TapGestureRecognizer.swift
//  Emerald
//
//  Created by Cristian Diaz on 24.10.2022.
//

import Beryllium
import Foundation
import SpriteKit

public class TapGestureRecognizer: GestureRecognizer {
    
    public var onTap: ((Position) -> Void)?
    
    public var timeout: TimeInterval = 0.35
    public var validRangeMagnitude: CGFloat = 5
    
    public init() {
    }
    
    public func beginWithTouchInfo(_ info: TouchInfo) {
        startInfo = info
    }
    
    public func endWithTouchInfo(_ info: TouchInfo) {
        defer {
            startInfo = nil
        }
        
        guard
            let startInfo,
            (info.timestamp - startInfo.timestamp) < timeout
        else {
            return
        }
        
        let magnitude = startInfo.position.distance(to: info.position)
        
        guard magnitude < validRangeMagnitude else {
            return
        }
        
        onTap?(startInfo.position)
    }
    
    // MARK: - Private
    
    private weak var node: Node?
    private var startInfo: TouchInfo?
}
