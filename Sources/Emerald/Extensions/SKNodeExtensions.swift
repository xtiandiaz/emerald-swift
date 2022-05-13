//
//  SKNodeExtensions.swift
//  Emerald
//
//  Created by Cristian Díaz on 8.8.2021.
//

import SpriteKit

extension SKNode {
    
    public var isVisible: Bool {
        get { !isHidden }
        set { isHidden = !newValue }
    }
    
    public func run(_ action: SKAction, withKey key: String, completion: @escaping () -> Void) {
        run(
            SKAction.sequence([ action, SKAction.run(completion) ]),
            withKey: key
        )
    }
    
    public func runAsync(_ action: SKAction, withKey key: String) async {
        await withUnsafeContinuation { continuation in
            run(action, withKey: key) {
                continuation.resume(returning: ())
            }
        }
    }
    
    public func runTask(forAction action: SKAction, withKey key: String) -> Task<Void, Never> {
        Task {
            await runAsync(action, withKey: key)
        }
    }
    
    public func addChildren(_ children: SKNode...) {
        addChildren(children)
    }
    
    public func addChildren(_ children: [SKNode]) {
        children.forEach {
            addChild($0)
        }
    }
}

extension SKSpriteNode {
    
    public convenience init(gradient: Gradient, size: CGSize) {
        self.init(
            texture: SKTexture(image: UIImage.gradient(gradient, size: size)),
            size: size
        )
    }
}
