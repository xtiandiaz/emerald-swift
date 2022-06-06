//
//  DragBoard.swift
//  Emerald
//
//  Created by Cristian Diaz on 14.5.2022.
//

import Beryllium
import Combine
import Foundation
import SpriteKit

open class DragBoard: Board {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard
            let pick = pick,
            let location = touches.first?.location(in: self)
        else {
            return
        }

        pick.token.position = location - pick.offset
    }
}
