//
//  Space.swift
//  Emerald
//
//  Created by Cristian Diaz on 6.7.2022.
//

import Foundation
import SwiftUI

open class Space<T: Token>: Identifiable, ObservableObject {
    
    @Published public internal(set) var sortingIndex = 0
    @Published public var isHighlighted = false
    
    open func canInteract(with token: T) -> Bool {
        fatalError("Not implemented")
    }
    
    open func interact(with token: T) {
        fatalError("Not implemented")
    }
    
    open func canPlace(token: T) -> Bool {
        fatalError("Not implemented")
    }
    
    // MARK: - Public
    
    public let id = UUID()
    
    public var tokenCapacity: Int {
        fatalError("Not implemented")
    }
    
    public var tokenCount: Int {
        fatalError("Not implemented")
    }
    
    public var isEmpty: Bool {
        tokenCount == 0
    }
    
    public func peek(at localPosition: CGPoint) -> T? {
        fatalError("Not implemented")
    }
    
    public func take(at localPosition: CGPoint) -> T? {
        fatalError("Not implemented")
    }
    
    public func place(token: T) {
        fatalError("Not implemented")
    }
    
    // MARK: - Internal
    
    var onPicked: ((T) -> Void)?
    var onDropped: ((T) -> Void)?
}
