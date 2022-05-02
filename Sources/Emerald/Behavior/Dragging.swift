//
//  Dragging.swift
//  Emerald
//
//  Created by Cristian Diaz on 23.4.2022.
//

import Beryllium
import Combine
import Foundation
import SpriteKit

public protocol PickableAndDroppable: Node {
    
    func pick()
    func drop()
}

public protocol Draggable: Node {
    
    var dragAxis: Axis { get }
    
    func pick() -> PickableAndDroppable?
    func onDragged(by offset: CGSize)
    func drop()
}

public class Dragging<T: Draggable>: NodeBehavior<T> {
    
    @Publish public private(set) var pick: PickableAndDroppable?
    
    public override func start() {
        super.start()
        
        node.isUserInteractionEnabled = true
    }
    
    // MARK: - Internal
    
    override func subscribe(_ subscriptions: inout Set<AnyCancellable>) {
        node.uponTouchBegan
            .sink { [unowned self] in
                if pick.isNil, let pick = node.pick() {
                    pickPosition = pick.position
                    pickLocation = $0.location(in: node)
                    self.pick = pick
                }
            }
            .store(in: &subscriptions)
        
        node.uponTouchMoved
            .sink { [unowned self] in
                guard let pick = pick else {
                    return
                }
                
                let nextLocation = $0.location(in: node)
                let nextPosition =  pickPosition - pickLocation + nextLocation
                
                pick.position = {
                    switch node.dragAxis {
                    case .x: return CGPoint(x: nextPosition.x, y: pick.position.y)
                    case .y: return CGPoint(x: pick.position.x, y: nextPosition.y)
                    default: return nextPosition
                    }
                }()
                
                node.onDragged(by: (nextLocation - pickLocation).asOffset())
            }
            .store(in: &subscriptions)
        
        node.uponTouchEnded
            .sink { [unowned self] _ in
                pick?.drop()
                pick = nil
                
                node.drop()
            }
            .store(in: &subscriptions)
    }
    
    // MARK: - Private
    
    private var pickPosition: CGPoint = .zero
    private var pickLocation: CGPoint = .zero
}
