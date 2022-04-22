//
//  MessageListener.swift
//  Emerald
//
//  Created by Cristian Diaz on 22.4.2022.
//

import Combine
import Foundation

public final class MessageListener<Message> {
    
    @Inject private var broker: MessageBroker<Message>
    
    public var onMessage: ((Message) -> Void)?
    
    public init() {
    }
    
    deinit {
        print("Destroyed LISTENER")
    }
    
    public func listen() -> Self {
        subscription = broker.uponMessage
            .sink { [unowned self] in
                onMessage?($0)
            }
        
        return self
    }
    
    public func ignore() {
        subscription?.cancel()
        subscription = nil
    }
    
    // MARK: - Private
    
    private var subscription: AnyCancellable?
}
