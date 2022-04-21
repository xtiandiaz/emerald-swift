//
//  PickableNode.swift
//  Emerald
//
//  Created by Cristian Diaz on 21.4.2022.
//

import Foundation
import SpriteKit

open class PickableNode<T: SKNode>: Node {
    
    public typealias Pick = (item: T, offset: CGPoint)
    
    @Publish public private(set) var currentPick: Pick?
    
    open var draggingAxis: Axis {
        .xy
    }
    
    open func pick() -> T? {
        nil
    }
    
    open func drop(_ item: T) {
        currentPick = nil
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            pick(at: touch.location(in: self))
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, let pick = currentPick {
            let position = touch.location(in: self) + pick.offset
            
            pick.item.position = {
                switch draggingAxis {
                case .x: return CGPoint(x: position.x, y: pick.item.position.y)
                case .y: return CGPoint(x: pick.item.position.x, y: position.y)
                default: return position
                }
            }()
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let item = currentPick?.item {
            drop(item)
        }
    }
    
    private func pick(at point: CGPoint) {
        guard currentPick.isNil, let pick = pick() else {
            return
        }
        
        currentPick = (item: pick, offset: pick.position - point)
    }
}
