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
    
    public var origin: PlaceType {
        place(forLocation: .zero)
    }
    
    public func nextPlace(fromLocation origin: Location, toward direction: Direction) -> PlaceType? {
        nextPlace(fromLocation: origin, toward: direction.extendedDirection)
    }
    
    public func nextPlace(fromLocation origin: Location, toward direction: ExtendedDirection) -> PlaceType? {
        if let nextLocation = nextLocation(fromOrigin: origin, toward: direction) {
            return place(forLocation: nextLocation)
        }
        return nil
    }
    
    public func place(forLocalPosition localPosition: Position) -> PlaceType? {
        if let location = location(forLocalPosition: localPosition) {
            return place(forLocation: location)
        }
        
        return nil
    }
}
