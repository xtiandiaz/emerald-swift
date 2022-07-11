//
//  TokenCollection.swift
//  Emerald
//
//  Created by Cristian Diaz on 6.7.2022.
//

import Beryllium
import Foundation
import SpriteKit

public protocol TokenCollection: Collection where Element: Token, Index == Int {
}

extension Stack: TokenCollection where Element: Token {
}

extension Queue: TokenCollection where Element: Token {
}
