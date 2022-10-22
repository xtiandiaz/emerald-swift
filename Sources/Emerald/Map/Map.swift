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
    
    func location(forLocalPosition localPosition: Position) -> Location?
    func nextLocation(fromOrigin origin: Location, toward direction: ExtendedDirection) -> Location?
    
    func place(forLocation location: Location) -> PlaceType
    
    func iterator() -> IndexingIterator<[PlaceType]>
}

extension Map {
    
    public func place(forLocalPosition localPosition: Position) -> PlaceType? {
        if let location = location(forLocalPosition: localPosition) {
            return place(forLocation: location)
        }
        
        return nil
    }
}
