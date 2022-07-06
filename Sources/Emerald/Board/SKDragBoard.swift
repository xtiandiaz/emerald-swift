//
//  SKDragBoard.swift
//  Emerald
//
//  Created by Cristian Diaz on 30.6.2022.
//

import Foundation
import SpriteKit

open class SKDragBoard<T: SKToken, S: SKSpace<T>>: AnyDragBoard, SKBoard {
    
    public typealias TokenType = T
    public typealias SpaceType = S
    
    public let spaces: [S]
    
    public init(spaces: [S], frame: CGRect) {
        self.spaces = spaces
        
        super.init(frame: frame)
        
        add(spaces: spaces)
    }
}
