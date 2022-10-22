//
//  SpaceSelectionStrategy.swift
//  Emerald
//
//  Created by Cristian Diaz on 19.10.2022.
//

import Foundation

public protocol SpaceSelectionStrategy {
    
    associatedtype SpaceType: Space & Place & Selectable
    associatedtype MapType: Map where MapType.PlaceType == SpaceType
    
    var delegate: (any SpaceSelectionDelegate<SpaceType>)? { get set }
    
    init(map: MapType)
    
    func selectAt(localPosition: CGPoint)
}
