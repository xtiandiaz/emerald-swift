//
//  Publish.swift
//  Emerald
//
//  Created by Cristian Diaz on 14.4.2022.
//

import Combine
import Foundation

@propertyWrapper
public class Publish<T> {
    
    public var wrappedValue: T {
        get { valueSubject.value }
        set { valueSubject.value = newValue }
    }
    
    public var projectedValue: AnyPublisher<T, Never> {
        valueSubject.eraseToAnyPublisher()
    }
    
    private let valueSubject: CurrentValueSubject<T, Never>
    
    public init(wrappedValue: T) {
        valueSubject = CurrentValueSubject<T, Never>(wrappedValue)
    }
}
