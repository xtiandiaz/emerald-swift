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

open class Scene: SKScene, Identifiable {
    
    open override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        installDependencies()
        
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
    }
    
    open func stop() {
        unsubscribe()
        removeDependencies()
    }
    
    open func removeDependencies() {
    }
    
    // MARK: - Public
    
    public let id = UUID()
    
    public private(set) lazy var gestures  = SceneGestureRecognizerManager(scene: self)
    
    public override init() {
        super.init()
    }
    
    public override init(size: CGSize) {
        super.init(size: size)
        
        addChildren()
    }
    
    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
