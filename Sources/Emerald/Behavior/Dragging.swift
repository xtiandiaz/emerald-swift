//
//  Dragging.swift
//  Emerald
//
//  Created by Cristian Diaz on 23.4.2022.
//

import Combine
import Foundation
import SpriteKit

public protocol Draggable: Node {
    
    var dragAxis: Axis { get }
    
    func pick() -> Draggable?
    func drag(to location: CGPoint)
    func drop()
}

extension Draggable {
    
    public func pick() -> Draggable? {
        self
    }

    public func drag(to location: CGPoint) {
        position = {
            switch dragAxis {
            case .x: return CGPoint(x: location.x, y: position.y)
            case .y: return CGPoint(x: position.x, y: location.y)
            default: return location
            }
        }()
    }
}

public class Dragging<T: Draggable>: NodeBehavior<T> {
    
    @Publish public private(set) var pick: Draggable?
    
    public override func start() {
        super.start()
        
        node.isUserInteractionEnabled = true
    }
    
    public override func subscribe(_ subscriptions: inout Set<AnyCancellable>) {
        node.uponTouchesBegan
            .sink { [unowned self] in
                if let touch = $0.first, pick.isNil, let pick = node.pick() {
                    pickOffset = pick.position - touch.location(in: pick)
                    self.pick = pick
                }
            }
            .store(in: &subscriptions)
        
        node.uponTouchesMoved
            .sink { [unowned self] in
                if let location = $0.first?.location(in: node), let pick = pick {
                    pick.drag(to: location + pickOffset)
                }
            }.store(in: &subscriptions)
        
        node.uponTouchesEnded
            .sink { [unowned self] _ in
                pick?.drop()
                pick = nil
            }
            .store(in: &subscriptions)
    }
    
    // MARK: - Private
    
    private var pickOffset: CGPoint = .zero
}
