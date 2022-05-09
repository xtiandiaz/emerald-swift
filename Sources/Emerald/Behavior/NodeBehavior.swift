//
//  NodeBehavior.swift
//  Emerald
//
//  Created by Cristian Diaz on 23.4.2022.
//

import Beryllium
import Combine
import Foundation
import SpriteKit

open class NodeBehavior<T: Node>: Configurable {

    public unowned let node: T

    public init(node: T) {
        self.node = node
    }
    
    deinit {
        stop()
    }

    open func start() {
        subscribe(&subscriptions)
    }

    open func stop() {
        unsubscribe()
    }
    
    open func subscribe(_ subscriptions: inout Set<AnyCancellable>) {
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
