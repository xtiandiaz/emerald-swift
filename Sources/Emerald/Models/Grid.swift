//
//  Grid.swift
//  Emerald
//
//  Created by Cristian Diaz on 13.10.2022.
//

import Beryllium
import Foundation

public final class Grid<CellContent>: Configurable {
    
    public typealias Position = CGPoint
    
    public struct Location: Equatable {
        
        public var x: Int
        public var y: Int
        public var index: Int
        
        // MARK: - Internal
        
        init(x: Int, y: Int, index: Int) {
            self.x = x
            self.y = y
            self.index = index
        }
    }
    
    public struct Cell {
        
        public let location: Location
        public let position: CGPoint
        public let content: CellContent
    }
    
    public let cols: Int
    public let rows: Int
    public let cellSize: CGSize
    public let size: CGSize
    
    public init(
        cols: Int,
        rows: Int,
        cellSize: CGSize,
        contentBlock: (Location, Position, CGSize) -> CellContent
    ) {
        self.cols = cols
        self.rows = rows
        self.cellSize = cellSize
        
        var contents = [CellContent]()
        contents.reserveCapacity(cols * rows)
        
        for row in 0..<rows {
            for col in 0..<cols {
                contents.append(contentBlock(
                    Self.locationAt(col: col, row: row, totalCols: cols),
                    Self.positionAt(col: col, row: row, cellSize: cellSize),
                    cellSize
                ))
            }
        }
        
        self.contents = contents
        
        size = Self.positionAt(col: cols - 1, row: rows - 1, cellSize: cellSize).offset() + cellSize
    }
    
    public subscript(index index: Int) -> CellContent {
        contents[index]
    }
    
    public subscript(col col: Int, row row: Int) -> CellContent {
        contents[row * cols + col]
    }
    
    public func cellAt(localPosition: CGPoint) -> Cell? {
        let col = Int(localPosition.x / cellSize.width)
        let row = Int(localPosition.y / cellSize.height)
        
        guard col < cols, row < rows else {
            return nil
        }
        
        return cellAt(col: col, row: row)
    }
    
    public func cellAt(col: Int, row: Int) -> Cell {
        .init(
            location: .init(x: col, y: row, index: row * cols + col),
            position: positionAt(col: col, row: row),
            content: self[col: col, row: row]
        )
    }
    
    public func cellAt(location: Location) -> Cell {
        .init(
            location: location,
            position: positionAt(col: location.x, row: location.y),
            content: self[col: location.x, row: location.y]
        )
    }
    
    public func positionAt(col: Int, row: Int) -> Position {
        Self.positionAt(col: col, row: row, cellSize: cellSize)
    }
    
    public func iterator() -> IndexingIterator<[CellContent]> {
        contents.makeIterator()
    }
    
    // MARK: - Internal
    
    static func locationAt(col: Int, row: Int, totalCols: Int) -> Location {
        .init(x: col, y: row, index: row * totalCols + col)
    }
    
    static func positionAt(col: Int, row: Int, cellSize: CGSize) -> Position {
        .init(x: col * cellSize.width, y: row * cellSize.height)
    }
    
    // MARK: - Private
    
    private let contents: [CellContent]
}
