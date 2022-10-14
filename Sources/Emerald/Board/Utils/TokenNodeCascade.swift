//
//  TokenNodeCascade.swift
//  Emerald
//
//  Created by Cristian Diaz on 14.10.2022.
//

import Beryllium
import Foundation

public class TokenNodeCascade<
    TokenNode: SKTokenNode,
    SpaceNode: SKUnitSpaceNode<TokenNode>,
    TokenNodeFactory: Factory<TokenNode>
> {
    
    public init(spaceGrid: Grid<SpaceNode>, tokenFactory: TokenNodeFactory) {
        grid = spaceGrid
        factory = tokenFactory
    }
    
    public func pour() {
        clear()
        
        for col in 0..<grid.cols {
            shiftTokensAt(col: col)
        }
    }
    
    // MARK: - Private
    
    private let grid: Grid<SpaceNode>
    private let factory: TokenNodeFactory
    private let disposer = TokenNodeDisposer()
    
    private func shiftTokensAt(col: Int, row: Int = 0, produceCount: Int = 0) {
        guard row < grid.rows else {
            return
        }
        
        if !grid[col: col, row: row].token.isNil {
            shiftTokensAt(col: col, row: row + 1, produceCount: produceCount)
            return
        }
        
        let destination = grid[col: col, row: row]
        var produce = produceCount
        
        if let source = sourceAbove(row: row, inCol: col), let token = source.token {
            source.release(token: token)
            
            destination.place(token: token)
        } else {
            let newToken = factory.produceOne().configure {
                $0.position.y += (grid.rows - row + produceCount) * grid.cellSize.height
            }
            
            destination.place(token: newToken)
            
            produce += 1
        }
        
        shiftTokensAt(col: col, row: row + 1, produceCount: produce)
    }
    
    private func sourceAbove(row: Int, inCol col: Int) -> SpaceNode? {
        guard row < grid.rows - 1 else {
            return nil
        }
        
        return (row..<grid.rows)
            .map { grid[col: col, row: $0] }
            .first { !$0.token.isNil }
    }
    
    private func clear() {
        grid.iterator().forEach {
            if let token = $0.token, token.isInvalidated {
                $0.release(token: token)
                disposer.disposeOf(node: token)
            }
        }
    }
}
