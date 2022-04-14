//
//  Inject.swift
//  Emerald
//
//  Created by Cristian Díaz on 28.2.2021.
//  Copyright © 2021 Berilio. All rights reserved.
//

import Foundation

@propertyWrapper
public struct Inject<T> {
    
    public var wrappedValue: T {
        mutating get { value }
        set { }
    }
    
    public init() {}
    
    // MARK: Private
    
    private lazy var value = try! InjectionController.shared.resolve(T.self)
}
