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
         translate(to: CGPoint),
         flip(times: Int, direction: Direction, flipBlock: (() -> Void)?),
         fadeOut
}

public struct NodeAnimationSettings {
    
    public static let `default` = NodeAnimationSettings(duration: 0.1, timingMode: .linear)
    
    var duration: CGFloat
    var timingMode: SKActionTimingMode
    var completionBlock: (() -> Void)?
    
    public init(
        duration: CGFloat = 0.1,
        timingMode: SKActionTimingMode = .linear,
        completionBlock: (() -> Void)? = nil
    ) {
        self.duration = duration
        self.timingMode = timingMode
        self.completionBlock = completionBlock
    }
}

public extension Node {
    
    func animate(_ animation: NodeAnimation, withKey key: String, settings: NodeAnimationSettings = .default) {
        removeAction(forKey: key)
        
        if let completion = settings.completionBlock {
            run(action(for: animation, settings: settings), withKey: key, completion: completion)
        } else {
            run(action(for: animation, settings: settings), withKey: key)
        }
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
            
        case .flip(let times, let direction, let block):
            let actions = flipScaleActions(for: direction, duration: settings.duration)
            
            return SKAction.repeat(
                SKAction.sequence([
                    actions.0,
                    SKAction.run { block?() },
                    actions.1,
                ]),
                count: times
            )
            
        case .fadeOut:
            return SKAction.fadeOut(withDuration: settings.duration)
        }
    }
    
    private func flipScaleActions(for direction: Direction, duration: CGFloat) -> (SKAction, SKAction) {
        (
            { () -> SKAction in
                switch direction {
                case .right, .left:
                    return SKAction.scaleX(to: 0, y: 1, duration: duration / 2)
                case .up, .down:
                    return SKAction.scaleX(to: 1, y: 0, duration: duration / 2)
                }
            }().configure {
                $0.timingMode = .easeIn
            },
            SKAction.scaleX(to: 1, y: 1, duration: duration / 2).configure {
                $0.timingMode = .easeOut
            }
        )
    }
}
