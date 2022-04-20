//
//  SKActionExtensions.swift
//  Emerald
//
//  Created by Cristian Diaz on 19.4.2022.
//

import Foundation
import SpriteKit

public extension SKAction {
    
    static func sequence(_ actions: SKAction...) -> SKAction {
        .sequence(actions)
    }
    
    static func group(_ actions: SKAction...) -> SKAction {
        .group(actions)
    }
    
    static func scale(to scale: CGFloat, duration: TimeInterval, timingMode: SKActionTimingMode) -> SKAction {
        .scale(to: scale, duration: duration).configure {
            $0.timingMode = timingMode
        }
    }
    
    static func move(to localPosition: CGPoint, duration: TimeInterval, timingMode: SKActionTimingMode) -> SKAction {
        .move(to: localPosition, duration: duration).configure {
            $0.timingMode = timingMode
        }
    }
    
    static func flip(
        times: Int,
        direction: Direction,
        flipDuration: TimeInterval,
        flipBlock: @escaping () -> Void
    ) -> SKAction {
        .repeat(
            .sequence(
                { () -> SKAction in
                    switch direction {
                    case .right, .left:
                        return .scaleX(to: 0, y: 1, duration: flipDuration / 2)
                    case .up, .down:
                        return .scaleX(to: 1, y: 0, duration: flipDuration / 2)
                    }
                }().configure {
                    $0.timingMode = .easeIn
                },
                .run { flipBlock() },
                .scaleX(to: 1, y: 1, duration: flipDuration / 2).configure {
                    $0.timingMode = .easeOut
                }
            ),
            count: times
        )
    }
}
