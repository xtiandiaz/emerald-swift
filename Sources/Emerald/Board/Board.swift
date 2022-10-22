//
//  Board.swift
//  Emerald
//
//  Created by Cristian Diaz on 18.10.2022.
//

import Foundation

public protocol Board: Identifiable, Equatable {
    
    associatedtype SpaceType: Space
    associatedtype MapType: Map where MapType.PlaceType == SpaceType
    
    var id: UUID { get }
    var map: MapType { get }
    
    func spaceAt(localPosition: Position) -> SpaceType?
}

extension Board {
    
    public func spaceAt(location: Location) -> SpaceType {
        map.place(forLocation: location)
    }
}

