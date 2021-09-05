//
//  Node.swift
//  Emerald
//
//  Created by Cristian Díaz on 4.9.2021.
//

import SpriteKit

open class Node: SKNode {
    
    public override init() {
        super.init()
    }
    
    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
