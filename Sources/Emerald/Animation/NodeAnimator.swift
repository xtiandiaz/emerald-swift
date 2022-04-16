//
//  NodeAnimator.swift
//  Emerald
//
//  Created by Cristian Diaz on 16.4.2022.
//

import Foundation
import SpriteKit

public enum NodeAnimation {
    
    case scale(to: CGFloat),
         translate(to: CGPoint)
}

public struct NodeAnimationSettings {
    
    public static let `default` = NodeAnimationSettings(duration: 0.1, timingMode: .linear)
    
    var duration: CGFloat
    var timingMode: SKActionTimingMode
    
    public init(duration: CGFloat = 0.1, timingMode: SKActionTimingMode) {
        self.duration = duration
        self.timingMode = timingMode
    }
}

public extension Node {
    
    func animate(_ animation: NodeAnimation, withKey key: String, settings: NodeAnimationSettings = .default) {
        removeAction(forKey: key)
        run(action(for: animation, settings: settings), withKey: key)
    }
    
    func action(
        for animation: NodeAnimation,
        settings: NodeAnimationSettings
    ) -> SKAction {
        switch animation {
        case .scale(let scale):
            return SKAction.scale(to: scale, duration: settings.duration).configure {
                $0.timingMode = settings.timingMode
            }
        case .translate(let localPosition):
            return SKAction.move(to: localPosition, duration: settings.duration).configure {
                $0.timingMode = settings.timingMode
            }
        }
    }
}
