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
            SKAction.sequence([
                action,
                SKAction.run(completion)
            ]),
            withKey: key
        )
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
