//
//  TokenCollection.swift
//  Emerald
//
//  Created by Cristian Diaz on 6.7.2022.
//

import Beryllium
import Foundation
import SpriteKit

public protocol TokenCollection: RandomAccessCollection where Element: UIToken, Index == Int {
    
    mutating func remove(_ item: Element) -> Element?
}

extension Stack: TokenCollection where Element: UIToken {
}

extension Queue: TokenCollection where Element: UIToken {
}

extension Array: TokenCollection where Element: UIToken {
}
