//
//  Token.swift
//  Emerald
//
//  Created by Cristian Diaz on 6.7.2022.
//

import Beryllium
import Foundation
import SwiftUI

public protocol FlatToken: Token {
    
    associatedtype FaceType: FlatTokenFace
    
    var front: FaceType { get }
    var back: FaceType? { get }
    
    var side: FlatTokenSide { get set }
}

open class Token: ObservableObject, Identifiable, Equatable, Configurable {
    
    @Published public internal(set) var layout: TokenLayout = .default
    @Published public internal(set) var styling: TokenStyling = .default
    @Published public internal(set) var isLocked = false
    @Published var isDraggable = true
    
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
    public var name: String?
    
    public private(set) var isInvalidated = false
    
    public init() {
    }
    
    public static func == (lhs: Token, rhs: Token) -> Bool {
        lhs.id == rhs.id
    }
    
    // MARK: - Internal
    
    var onPicked: (() -> Void)?
    var onDropped: ((Offset) -> Void)?
    var onPushed: ((Direction, Offset) -> Void)?
    
    var placementOffset: CGSize = .zero
}
