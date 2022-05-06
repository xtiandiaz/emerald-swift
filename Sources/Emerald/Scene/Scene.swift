//
//  Scene.swift
//  Emerald
//
//  Created by Cristian Diaz on 15.4.2022.
//

import Beryllium
import Combine
import Foundation
import SpriteKit

open class Scene: SKScene, Runnable, Identifiable {
    
    public let id = UUID()
    public private(set) var isRunning = false
    public private(set) var subscriptions = Set<AnyCancellable>()
    
    public override init() {
        super.init()
    }
    
    public override init(size: CGSize) {
        super.init(size: size)
        
        installDependencies()
        addChildren()
    }
    
    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        start()
    }
    
    open func installDependencies() {
    }
    
    open func addChildren() {
    }

    open func subscribe(_ subscriptions: inout Set<AnyCancellable>) {
    }
    
    open func start() {
        subscribe(&subscriptions)
        
        isRunning = true
    }
    
    open func stop() {
        unsubscribe()
        removeDependencies()
        
        isRunning = false
    }
    
    open func removeDependencies() {
    }
    
    // MARK: - Private
    
    private func unsubscribe() {
        subscriptions.forEach {
            $0.cancel()
        }
        
        subscriptions.removeAll()
    }
}
