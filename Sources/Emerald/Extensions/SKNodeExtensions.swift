//
//  SKNodeExtensions.swift
//  Emerald
//
//  Created by Cristian Díaz on 8.8.2021.
//

import SpriteKit

public extension SKNode {
    
    var isVisible: Bool {
        get { !isHidden }
        set { isHidden = !newValue }
    }
    
    func run(_ action: SKAction, withKey key: String, completion: @escaping () -> Void) {
        run(
            SKAction.sequence([ action, SKAction.run(completion) ]),
            withKey: key
        )
    }
    
    func runAsync(_ action: SKAction, withKey key: String) async {
        await withUnsafeContinuation { continuation in
            run(action, withKey: key) {
                continuation.resume(returning: ())
            }
        }
    }
    
    func runTask(forAction action: SKAction, withKey key: String) -> Task<Void, Never> {
        Task {
            await runAsync(action, withKey: key)
        }
    }
    
    func addChildren(_ children: SKNode...) {
        children.forEach {
            addChild($0)
        }
    }
}

public extension SKSpriteNode {
    
    convenience init(gradient: Gradient, size: CGSize) {
        self.init(
            texture: SKTexture(image: UIImage.gradient(gradient, size: size)),
            size: size
        )
    }
}
