//
//  TokenNodeDisposer.swift
//  Emerald
//
//  Created by Cristian Diaz on 23.5.2022.
//

import Foundation
import SpriteKit

public struct TokenNodeDisposer {
    
    public init() {
    }
    
    public func disposeIfInvalidatedOf(nodes: [any SKTokenNode]) {
        nodes.forEach {
            disposeIfInvalidatedOf(node: $0)
        }
    }
    
    public func disposeIfInvalidatedOf(node: any SKTokenNode) {
        if node.isInvalidated {
            disposeOf(node: node)
        }
    }
    
    public func disposeOf(nodes: [any SKTokenNode]) {
        nodes.forEach {
            disposeOf(node: $0)
        }
    }
    
    public func disposeOf(node: any SKTokenNode) {
        if let disposalAction = node.disposalAction() {
            node.run(disposalAction, withKey: "disposal") { [unowned node] in
                node.removeFromParent()
            }
        } else {
            node.removeFromParent()
        }
    }
}
