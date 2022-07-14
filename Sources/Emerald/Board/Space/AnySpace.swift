//
//  AnySpace.swift
//  Emerald
//
//  Created by Cristian Diaz on 14.7.2022.
//

import Beryllium
import Foundation
import SwiftUI

open class AnySpace: ObservableObject, Identifiable, Equatable, Configurable {
    
    @Published public var isSelected = false
    @Published public var isHighlighted = false
    
    public let id = UUID()
    
    public var tokenCapacity: Int {
        fatalError("Not implemented")
    }
    
    public var tokenCount: Int {
        fatalError("Not implemented")
    }
    
    public var isEmpty: Bool {
        fatalError("Not implemented")
    }
    
    public static func == (lhs: AnySpace, rhs: AnySpace) -> Bool {
        lhs.id == rhs.id
    }
    
    // MARK: - Internal
    
    var onPicked: ((Token) -> Void)?
    var onDropped: ((Token, CGSize) -> Void)?
    
    func canInteract(with token: Token) -> Bool {
        fatalError("Not implemented")
    }
    
    func interact(with token: Token) {
        fatalError("Not implemented")
    }
    
    func canPlace(token: Token) -> Bool {
        fatalError("Not implemented")
    }
    
    func place(token: Token) {
        fatalError("Not implemented")
    }
    
    func remove(token: Token) -> Token? {
        fatalError("Not implemented")
    }
}
