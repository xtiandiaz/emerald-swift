//
//  Token.swift
//  Emerald
//
//  Created by Cristian Diaz on 6.7.2022.
//

import Beryllium
import Foundation
import SwiftUI

open class Token: ObservableObject, Identifiable, Equatable, Configurable {
    
    @Published public internal(set) var layout: TokenLayout = .default
    @Published public internal(set) var styling: TokenStyling = .default
    @Published public internal(set) var isLocked = false
    
    public internal(set) var dragOffset: CGSize = .zero
    
    open func canInteract(with other: Token) -> Bool {
        fatalError("Not implemented")
    }
    
    open func interact(with other: Token) {
        fatalError("Not implemented")
    }
    
    open func invalidate() {
        isInvalidated = true
    }
    
    // MARK: - Public
    
    public let id = UUID()
    
    public internal(set) var onPicked: (() -> Void)?
    public internal(set) var onDropped: ((CGSize) -> Void)?
    
    public private(set) var isInvalidated = false
    
    public init() {
    }
    
    public static func == (lhs: Token, rhs: Token) -> Bool {
        lhs.id == rhs.id
    }
}

public protocol FlatToken: Token {
    
    associatedtype FaceType: FlatTokenFace
    
    var front: FaceType { get }
    var back: FaceType? { get }
    
    var side: FlipSide { get set }
}

