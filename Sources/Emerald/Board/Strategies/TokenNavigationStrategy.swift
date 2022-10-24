//
//  TokenNavigationStrategy.swift
//  Emerald
//
//  Created by Cristian Diaz on 22.10.2022.
//

import Beryllium
import Foundation

public protocol TokenNavigationStrategy: Configurable {
    
    associatedtype SpaceType: Space & Place
    associatedtype MapType: Map where MapType.PlaceType == SpaceType
    
    init(map: MapType)
}
