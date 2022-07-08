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
    
//    mutating func peek(at localPosition: CGPoint) -> Element?
//    mutating func take(at localPosition: CGPoint) -> Element?
//
//    func canInteract(with token: Element) -> Bool
//    func interact(with token: Element)
}

extension Stack: TokenCollection where Element: Token {
    
//    public func peek(at localPosition: CGPoint) -> Element? {
//        peek()
//    }
//
//    public mutating func take(at localPosition: CGPoint) -> Element? {
//        pop()
//    }
//
//    public func canInteract(with token: Element) -> Bool {
//        peek()?.canInteract(with: token) == true
//    }
//
//    public func interact(with token: Element) {
//        peek()?.interact(with: token)
//    }
}

extension Queue: TokenCollection where Element: Token {
    
//    public func peek(at localPosition: CGPoint) -> Element? {
//        peek()
//    }
//    
//    public mutating func take(at localPosition: CGPoint) -> Element? {
//        poll()
//    }
//    
//    public func canInteract(with token: Element) -> Bool {
//        peek()?.canInteract(with: token) == true
//    }
//    
//    public func interact(with token: Element) {
//        peek()?.interact(with: token)
//    }
}
