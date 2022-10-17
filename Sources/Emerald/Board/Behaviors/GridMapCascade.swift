//
//  GridMapCascade.swift
//  Emerald
//
//  Created by Cristian Diaz on 17.10.2022.
//

import Beryllium
import Foundation

open class GridBoardCascade<
    TokenNode: SKTokenNode,
    SpaceNode: SKUnitSpaceNode<TokenNode> & Place
>: BoardBehavior {
    
    open func run() {
        clear()
        
        for col in 0..<board.map.cols {
            shiftContentsAt(col: col)
        }
    }
    
    open func produceOneToken(withSize size: CGSize) -> TokenNode {
        fatalError("Not implemented")
    }
    
    open func disposeOfToken(_ token: TokenNode) {
        fatalError("Not implemented")
    }
    
    // MARK: - Public
    
    public required init(board: SKGridBoardNode<SpaceNode>) {
        self.board = board
    }
    
    public func clear() {
        board.map.iterator().forEach {
            if let token = $0.token, token.isInvalidated {
                $0.release(token: token)
                disposeOfToken(token)
            }
        }
    }
    
    // MARK: - Private
    
    private let board: SKGridBoardNode<SpaceNode>
    
    private func shiftContentsAt(col: Int, row: Int = 0, produceCount: Int = 0) {
        guard row < board.map.rows else {
            return
        }
        
        if !board.map[col: col, row: row].token.isNil {
            shiftContentsAt(col: col, row: row + 1, produceCount: produceCount)
            return
        }
        
        let destination = board.map[col: col, row: row]
        var produce = produceCount
        
        if let source = sourceAbove(row: row, inCol: col), let token = source.token {
            source.release(token: token)
            
            destination.place(token: token)
        } else {
            let newToken = produceOneToken(withSize: board.map.placeSize).configure {
                $0.position.y += (board.map.rows - row + produceCount) * board.map.placeSize.height
            }
            
            destination.place(token: newToken)
            
            produce += 1
        }
        
        shiftContentsAt(col: col, row: row + 1, produceCount: produce)
    }
    
    private func sourceAbove(row: Int, inCol col: Int) -> SpaceNode? {
        guard row < board.map.rows - 1 else {
            return nil
        }
        
        return (row..<board.map.rows)
            .map { board.map[col: col, row: $0] }
            .first { !$0.token.isNil }
    }
}
