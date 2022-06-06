//
//  UIGestureRecognizerExtension.swift
//  Emerald
//
//  Created by Cristian Diaz on 3.6.2022.
//

import Foundation
import UIKit
import SpriteKit

extension UISwipeGestureRecognizer.Direction {
    
    public var sceneDirection: Direction {
        switch self {
        case .up: return .down
        case .right: return .right
        case .down: return .up
        case .left: return .left
        default:
            fatalError()
        }
    }
}

extension UIGestureRecognizer {
    
    public func locationInNode(_ node: SKNode) -> CGPoint? {
        if let view = view as? SKView, let scene = view.scene {
            return node.convert(view.convert(location(in: view), to: scene), from: scene)
        }
        
        return nil
    }
}
