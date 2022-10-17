//
//  BoardBehavior.swift
//  Emerald
//
//  Created by Cristian Diaz on 17.10.2022.
//

import Foundation

public protocol BoardBehavior {
    
    associatedtype BoardType: _Board
    
    typealias TokenType = BoardType.SpaceType.TokenType
    
    init(board: BoardType)
    
    func run()
    
    func produceOneToken(withSize size: CGSize) -> TokenType
    func disposeOfToken(_ token: TokenType)
}
