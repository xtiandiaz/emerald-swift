//
//  TokenCollection.swift
//  Emerald
//
//  Created by Cristian Diaz on 6.7.2022.
//

import Beryllium
import Foundation
import SpriteKit

public protocol TokenCollection: ArrayProtocol where Element: Token, Index == Int {
    
    mutating func remove(_ item: Element) -> Element?
}

extension Stack: TokenCollection where Element: Token {
}

extension Queue: TokenCollection where Element: Token {
}
