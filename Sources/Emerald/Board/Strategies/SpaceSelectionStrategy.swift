//
//  SpaceSelectionStrategy.swift
//  Emerald
//
//  Created by Cristian Diaz on 19.10.2022.
//

import Beryllium
import Foundation

public protocol SpaceSelectionStrategy: Configurable {
    
    associatedtype SpaceType: Space & Place & Selectable
    associatedtype MapType: Map where MapType.PlaceType == SpaceType
//    associatedtype Delegate: SpaceSelectionDelegate where Delegate.SpaceType == SpaceType
    
    var delegate: (any SpaceSelectionDelegate<SpaceType>)? { get set }
    
    init(map: MapType)
    
    func selectAt(localPosition: CGPoint)
}
