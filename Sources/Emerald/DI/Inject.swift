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
    
    private lazy var value = try! InjectionContainer.shared.resolve(T.self)
    
    public init() {}
}
