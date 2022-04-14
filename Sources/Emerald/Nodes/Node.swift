//
//  Node.swift
//  Emerald
//
//  Created by Cristian Díaz on 4.9.2021.
//

import SpriteKit

open class Node: SKNode {
    
    public var width: CGFloat {
        frame.width
    }
    
    public var height: CGFloat {
        frame.height
    }
    
    public var size: CGSize {
        frame.size
    }
    
    public override init() {
        super.init()
    }
    
    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
