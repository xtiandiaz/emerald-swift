//
//  ConnectableTimer.swift
//  Emerald
//
//  Created by Cristian Díaz on 18.10.2020.
//

import Combine

class ConnectableTimer {
    
    let publisher: Timer.TimerPublisher
    
    init(interval: TimeInterval) {
        publisher = Timer.publish(every: interval, on: .main, in: .default)
    }
    
    deinit {
        cancel()
    }
    
    func connect() {
        cancellable = publisher.connect()
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
    // MARK: Private
    
    private var cancellable: Cancellable?
}
