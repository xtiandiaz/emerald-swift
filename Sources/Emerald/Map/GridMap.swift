//
//  GridMap.swift
//  Emerald
//
//  Created by Cristian Diaz on 16.10.2022.
//

import Beryllium
import Foundation

public final class GridMap<PlaceType: Place>: Map {
    
    public let cols: Int
    public let rows: Int
    public let placeSize: CGSize
    public let size: CGSize
    
    public init(
        cols: Int,
        rows: Int,
        placeSize: CGSize,
        placeAt: (Location, CGPoint, CGSize) -> PlaceType
    ) {
        self.cols = cols
        self.rows = rows
        self.placeSize = placeSize
        
        var places = [PlaceType]()
        places.reserveCapacity(cols * rows)
        
        for row in 0..<rows {
            for col in 0..<cols {
                places.append(placeAt(
                    Self.locationAt(col: col, row: row, totalCols: cols),
                    Self.positionAt(col: col, row: row, placeSize: placeSize),
                    placeSize
                ))
            }
        }
        
        self.places = places
        
        size = Self.positionAt(col: cols - 1, row: rows - 1, placeSize: placeSize).offset() + placeSize
    }
    
    public subscript(index index: Int) -> PlaceType {
        places[index]
    }
    
    public subscript(col col: Int, row row: Int) -> PlaceType {
        places[row * cols + col]
    }
    
    public func locationAt(localPosition: CGPoint) -> Location? {
        let col = Int(localPosition.x / placeSize.width)
        let row = Int(localPosition.y / placeSize.height)
        
        guard col < cols, row < rows else {
            return nil
        }
        
        return .init(x: col, y: row, index: row * cols + col)
    }
    
    public func nextLocationFrom(origin: Location, toward direction: ExtendedDirection) -> Location? {
        var x = origin.x
        var y = origin.y
        
        switch direction {
        case .up: y += 1
        case .upRight:
            x += 1
            y += 1
        case .right: x += 1
        case .downRight:
            x += 1
            y -= 1
        case .down: y -= 1
        case .downLeft:
            x -= 1
            y -= 1
        case .left: x -= 1
        case .upLeft:
            x -= 1
            y += 1
        }
        
        guard x >= 0, x < cols, y >= 0, y < rows else {
            return nil
        }
        
        return .init(x: x, y: y, index: y * cols + x)
    }
    
    public func placeAt(location: Location) -> PlaceType {
        places[location.index]
    }
    
    public func iterator() -> IndexingIterator<[PlaceType]> {
        places.makeIterator()
    }
    
    // MARK: - Internal
    
    static func locationAt(col: Int, row: Int, totalCols: Int) -> Location {
        .init(x: col, y: row, index: row * totalCols + col)
    }
    
    static func positionAt(col: Int, row: Int, placeSize: CGSize) -> CGPoint {
        .init(x: col * placeSize.width, y: row * placeSize.height)
    }
    
    // MARK: - Private
    
    private let places: [PlaceType]
}
