//
//  SKNodeExtensions.swift
//  Emerald
//
//  Created by Cristian Díaz on 8.8.2021.
//

import SpriteKit

public extension SKSpriteNode {
    
    convenience init(gradient: Gradient, size: CGSize) {
        self.init(
            texture: SKTexture(image: UIImage.gradient(gradient, size: size)),
            size: size
        )
    }
}
