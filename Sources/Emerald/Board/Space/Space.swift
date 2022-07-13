//
//  Space.swift
//  Emerald
//
//  Created by Cristian Diaz on 6.7.2022.
//

import Beryllium
import Combine
import Foundation
import SwiftUI

open class Space<T: Token>: ObservableObject, Identifiable, Equatable, Configurable {
    
    @Published public var isSelected = false
    @Published public var isHighlighted = false
    @Published var layout: SpaceLayout<T>
    
    open func canInteract(with token: T) -> Bool {
        fatalError("Not implemented")
    }
    
    open func interact(with token: T) {
        fatalError("Not implemented")
    }
    
    open func canPlace(token: T) -> Bool {
        fatalError("Not implemented")
    }
    
    open func arrange() {
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
    
    public init(layout: SpaceLayout<T>, styling: SpaceStyling<T>? = nil) {
        self.layout = layout
        self.styling = styling
    }
    
    public static func == (lhs: Space, rhs: Space) -> Bool {
        lhs.id == rhs.id
    }
    
    public func place(token: T) {
        fatalError("Not implemented")
    }
    
    // MARK: - Internal
    
    let styling: SpaceStyling<T>?
    
    var onPicked: ((T) -> Void)?
    var onDropped: ((T, CGSize) -> Void)?
    
    func remove(token: T) -> T? {
        fatalError("Not implemented")
    }
}
