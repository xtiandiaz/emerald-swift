//
//  Token.swift
//  Emerald
//
//  Created by Cristian Diaz on 6.7.2022.
//

import Beryllium
import Foundation
import SwiftUI

open class Token: Identifiable, ObservableObject, Configurable {
    
    @Published public internal(set) var sortingIndex = 0
    @Published public internal(set) var isLocked = false
    
    open func canInteract(with other: Token) -> Bool {
        fatalError("Not implemented")
    }
    
    open func interact(with other: Token) {
        fatalError("Not implemented")
    }
    
    // MARK: - Public
    
    public let id = UUID()
    
    public internal(set) var onPicked: (() -> Void)?
    public internal(set) var onDropped: (() -> Void)?
    
    public init() {
    }
}

public protocol FlatToken: Token {
    
    associatedtype FaceType: FlatTokenFace
    
    var front: FaceType { get }
    var back: FaceType? { get }
    
    var side: FlipSide { get set }
}

