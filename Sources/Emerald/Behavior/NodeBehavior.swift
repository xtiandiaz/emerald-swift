//
//  NodeBehavior.swift
//  Emerald
//
//  Created by Cristian Diaz on 23.4.2022.
//

import Combine
import Foundation
import SpriteKit

public class NodeBehavior<Behavior: Node> {

    public unowned let node: Behavior

    public init(node: Behavior) {
        self.node = node
    }
    
    deinit {
        stop()
    }

    public func start() {
        subscribe(&subscriptions)
    }

    public func stop() {
        unsubscribe()
    }
    
    // MARK: - Internal
    
    func subscribe(_ subscriptions: inout Set<AnyCancellable>) {
    }
        
    // MARK: - Private
    
    private var subscriptions = Set<AnyCancellable>()
    
    private func unsubscribe() {
        subscriptions.forEach {
            $0.cancel()
        }
        
        subscriptions.removeAll()
    }
}
