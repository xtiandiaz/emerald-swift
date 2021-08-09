//
//  Utils.swift
//  Emerald
//
//  Created by Cristian Díaz on 29.7.2021.
//

import Foundation

public func with<T>(_ object: T?, _ closure: (T) -> Void) {
    if let object = object {
        closure(object)
    }
}

public protocol Configurable {
    associatedtype T = Self
    func configure(_ closure: (T) -> Void) -> T
}

public extension Configurable {
    
    @discardableResult
    func configure(_ closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
}

extension NSObject: Configurable {}
