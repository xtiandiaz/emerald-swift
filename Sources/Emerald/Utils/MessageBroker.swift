//
//  MessageBroker.swift
//  Emerald
//
//  Created by Cristian Diaz on 20.4.2022.
//  Copyright © 2022 Berilio. All rights reserved.
//

import Combine
import Foundation

open class MessageBroker<Message> {
    
    public var uponMessage: AnyPublisher<Message, Never> {
        messageSubject.share().eraseToAnyPublisher()
    }
    
    public func send(_ message: Message) {
        messageSubject.send(message)
    }
    
    public init() {
    }
    
    // MARK: - Private
    
    private let messageSubject = PassthroughSubject<Message, Never>()
}
