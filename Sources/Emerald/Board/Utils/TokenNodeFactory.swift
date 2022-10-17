//
//  TokenNodeFactory.swift
//  Emerald
//
//  Created by Cristian Diaz on 14.10.2022.
//

import Foundation

public protocol Factory<Product> {
    
    associatedtype Product
    
    func produceOne(withSize size: CGSize) -> Product
}
