//
//  SKGridSectionNode.swift
//  Emerald
//
//  Created by Cristian Diaz on 13.10.2022.
//

import Foundation

open class SKGridSectionNode<SpaceNode: SKSpaceNode>: SKSectionNode {
    
    public typealias SpaceGrid = Grid<SpaceNode>
    
    public override var size: CGSize {
        grid.size
    }
    
    public init(grid: Grid<SpaceNode>) {
        self.grid = grid
        
        super.init()
        
        grid.iterator().forEach {
            addChild($0)
        }
        
        isUserInteractionEnabled = true
    }
    
    public func cellAt(localPosition: CGPoint) -> SpaceGrid.Cell? {
        grid.cellAt(localPosition: localPosition)
    }
    
    public func cellAt(location: SpaceGrid.Location) -> SpaceGrid.Cell {
        grid.cellAt(location: location)
    }
    
    public func spaceAt(localPosition: CGPoint) -> SpaceNode? {
        if let cell = cellAt(localPosition: localPosition) {
            return cell.content
        }
        
        return nil
    }
    
    public func spaceAt(location: SpaceGrid.Location) -> SpaceNode {
        grid[index: location.index]
    }
    
    // MARK: - Private
    
    private let grid: Grid<SpaceNode>
}
