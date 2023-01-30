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
    public var name: String?
    
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
    
    var onPicked: ((UIToken) -> Void)?
    var onDropped: ((UIToken, Offset) -> Void)?
    var onPushed: ((UIToken, Direction, Offset) -> Void)?
    
    var frame = CGRect()
    
    var bounds: CGRect {
        CGRect(size: frame.size)
    }
    
    func canInteract(with token: UIToken) -> Bool {
        fatalError("Not implemented")
    }
    
    func interact(with token: UIToken) {
        fatalError("Not implemented")
    }
    
    func canPlace(token: UIToken) -> Bool {
        fatalError("Not implemented")
    }
    
    func place(token: UIToken) {
        fatalError("Not implemented")
    }
    
    func remove(token: UIToken) -> UIToken? {
        fatalError("Not implemented")
    }
}
