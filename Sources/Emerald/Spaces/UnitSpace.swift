//
//  UnitSpace.swift
//  Emerald
//
//  Created by Cristian Diaz on 26.5.2022.
//

import Foundation
import SpriteKit

//open class UnitSpace<T: Token>: Node, Space {
//    
//    open func canPlace(token: T) -> Bool {
//        false
//    }
//    
//    open func arrange() {
//        unit?.runIfValid(
//            .move(to: .zero, duration: 0.1, timingMode: .easeOut),
//            withKey: "arrangement"
//        )
//    }
//    
//    open func setHighlighted(_ highlighted: Bool) {
//    }
//    
//    // MARK: - Public
//    
//    public let capacity = 1
//    
//    public var isEmpty: Bool {
//        unit.isNil
//    }
//    
//    public func pickToken(at location: CGPoint) -> T? {
//        if let unit = unit, !unit.isLocked {
//            self.unit = nil
//            return unit
//        }
//        
//        return nil
//    }
//    
//    public func canPlace(token: T) -> Bool {
//        unit.isNil && accepts(token: token)
//    }
//    
//    public func place(token: T) -> T? {
//        place(token: token) {
//            unit = $0
//        }
//    }
//    
//    public func purge() -> [Token] {
//        if let unit = unit, unit.isInvalidated {
//            return [unit]
//        }
//        
//        return []
//    }
//    
//    // MARK: - Private
//    
//    private var unit: T?
//}
