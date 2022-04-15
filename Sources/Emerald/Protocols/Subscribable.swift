//
//  Subscribable.swift
//  Emerald
//
//  Created by Cristian Diaz on 15.4.2022.
//

import Combine
import Foundation

public protocol Subscribable {
    
    var subscriptions: Set<AnyCancellable> { get }
    
    func subscribe(_ subscriptions: inout Set<AnyCancellable>)
    func unsubscribe()
}
