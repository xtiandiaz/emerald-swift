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

public extension NSObjectProtocol {
    
    @discardableResult
    func configure(_ closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
}