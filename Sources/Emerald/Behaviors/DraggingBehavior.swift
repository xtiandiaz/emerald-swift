//
//  DraggingBehavior.swift
//  Emerald
//
//  Created by Cristian Diaz on 12.5.2022.
//

import Combine
import Foundation
import SpriteKit

public final class DraggingBehavior<Target: Draggable>: NodeBehavior<Target> {
    
    public override func start() {
        super.start()
        
        node.isUserInteractionEnabled = true
    }
    
    public override func stop() {
        super.stop()
        
        node.isUserInteractionEnabled = false
    }
    
    public override func subscribe(_ subscriptions: inout Set<AnyCancellable>) {
        node.touchBeganPublisher
            .sink { [unowned self] in pick(at: $0.location(in: node.parent!)) }
            .store(in: &subscriptions)
        
        node.touchMovedPublisher
            .sink { [unowned self] in drag(to: $0.location(in: node.parent!)) }
            .store(in: &subscriptions)
        
        node.touchEndedPublisher
            .sink { [unowned self] _ in drop() }
            .store(in: &subscriptions)
    }
    
    // MARK: - Private
    
    private var localPickPosition: CGPoint = .zero
    
    private func pick(at location: CGPoint) {
        localPickPosition = node.position - location
        node.pick()
    }
    
    private func drag(to location: CGPoint) {
        print(location)
        node.drag(to: location + localPickPosition)
    }
    
    private func drop() {
        node.drop()
    }
}
