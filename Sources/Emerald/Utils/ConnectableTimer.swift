//
//  ConnectableTimer.swift
//  Emerald
//
//  Created by Cristian Díaz on 18.10.2020.
//

import Foundation
import Combine

public class ConnectableTimer {
    
    public let publisher: Timer.TimerPublisher
    
    public init(interval: TimeInterval) {
        publisher = Timer.publish(every: interval, on: .main, in: .default)
    }
    
    deinit {
        cancel()
    }
    
    public func connect() {
        cancellable = publisher.connect()
    }
    
    public func cancel() {
        cancellable?.cancel()
    }
    
    // MARK: Private
    
    private var cancellable: Cancellable?
}
