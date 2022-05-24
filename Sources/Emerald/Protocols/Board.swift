//
//  Board.swift
//  Emerald
//
//  Created by Cristian Diaz on 14.5.2022.
//

import Foundation
import SpriteKit

public protocol Board: Node {
    
    var spaces: [Space] { get }
    
    var isLocked: Bool { get set }
    
    func addSpace(_ space: Space)
    func bridge(_ other: Self)
}

extension Board {
    
//    func put(token source: Token, from origin: Space, into destination: Space) {
//        let location = source.convert(source.position, to: destination)
//        
//        guard let target = destination.pickToken(at: location) else {
//            
//            return
//        }
//        
//        switch (source, target) {
//        case (let swappableSource as Swappable, let swappableDestination as Swappable):
//            break
//        default:
//            destination.place(token: source)
//        }
//    }
}
