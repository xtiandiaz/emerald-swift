//
//  SKBoardSectionNode.swift
//  Emerald
//
//  Created by Cristian Diaz on 13.10.2022.
//

import Foundation

open class SKGridBoardNode<SpaceNode: SKSpaceNode & Place>: SKBoardNode {
    
    public private(set) var map: GridMap<SpaceNode>
    
    public init(map: GridMap<SpaceNode>) {
        self.map = map
        
        super.init()
        
        map.iterator().forEach {
            addChild($0)
        }
        
        isUserInteractionEnabled = true
    }
    
    public func spaceAt(localPosition: Position) -> SpaceNode? {
        map.placeAt(localPosition: localPosition)
    }
}
