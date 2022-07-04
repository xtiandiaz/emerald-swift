//
//  UnitSpace.swift
//  Emerald
//
//  Created by Cristian Diaz on 26.5.2022.
//

import Foundation
import SpriteKit

open class UnitSpace<T: Token>: Space<T> {
    
    open override func canPlace(token: T) -> Bool {
        unit.isNil
    }
    
    open override func place(token: T) {
        place(token: token) {
            unit = $0
        }
    }
    
    open override func arrange() {
        unit?.runIfValid(
            .move(to: .zero, duration: 0.1, timingMode: .easeOut),
            withKey: "arrangement"
        )
    }
    
    // MARK: - Public
    
    public override var tokenCount: Int {
        unit.isNil ? 0 : 1
    }
    
    public override var tokenCapacity: Int {
        1
    }
    
    public override var isEmpty: Bool {
        unit.isNil
    }
    
    public override func peek(at localPosition: CGPoint) -> T? {
        if let unit = unit, unit.contains(localPosition) {
            return unit
        }
        
        return nil
    }
    
    public override func take(at localPosition: CGPoint) -> T? {
        if let unit = peek(at: localPosition) {
            defer { self.unit = nil }
            return unit
        }
        
        return nil
    }
    
    public override func canInteractWith(token: T) -> Bool {
        false
    }
    
    public override func canSwapWith(token: T) -> Bool {
        false
    }
    
    public override func purge() -> [AnyToken] {
        if let unit = unit, unit.isInvalidated {
            return [unit]
        }
        
        return []
    }
    
    // MARK: - Internal
    
    override func restore(token: T) {
        place(token: token)
    }
    
    // MARK: - Private
    
    private var unit: T?
}
