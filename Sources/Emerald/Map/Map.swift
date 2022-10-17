//
//  Map.swift
//  Emerald
//
//  Created by Cristian Diaz on 16.10.2022.
//

import Beryllium
import Foundation

public protocol Map {
    
    associatedtype PlaceType: Place
    
    var size: CGSize { get }
    
    func locationAt(localPosition: Position) -> Location?
    func nextLocationFrom(origin: Location, toward direction: ExtendedDirection) -> Location?
    
    func placeAt(location: Location) -> PlaceType
    
    func iterator() -> IndexingIterator<[PlaceType]>
}

extension Map {
    
    public func placeAt(localPosition: Position) -> PlaceType? {
        if let location = locationAt(localPosition: localPosition) {
            return placeAt(location: location)
        }
        
        return nil
    }
}
