//
//  DragBoard.swift
//  Emerald
//
//  Created by Cristian Diaz on 30.6.2022.
//

import Foundation
import SpriteKit

open class DragBoard<T: Token, S: Space<T>>: AnyDragBoard, Board {
    
    public typealias TokenType = T
    public typealias SpaceType = S
    
    public let spaces: [S]
    
    public init(frame: CGRect, spaces: [S]) {
        self.spaces = spaces
        
        super.init(frame: frame)
    }
}
