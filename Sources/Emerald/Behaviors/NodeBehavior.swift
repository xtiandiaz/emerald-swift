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

open class NodeBehavior<T: Node>: Runnable, Configurable {

    public unowned let node: T
    
    public private(set) var isRunning = false

    public init(node: T) {
        self.node = node
    }
    
    deinit {
        stop()
    }

    open func start() {
        guard !isRunning else {
            return
        }
        
        subscribe(&subscriptions)
        
        isRunning = true
    }
    
    open func stop() {
        guard isRunning else {
            return
        }
        
        unsubscribe()
        
        isRunning = false
    }
    
    open func cancel() {
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
