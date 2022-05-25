//
//  MessageBroadcaster.swift
//  Emerald
//
//  Created by Cristian Diaz on 20.4.2022.
//  Copyright © 2022 Berilio. All rights reserved.
//

import Combine
import Foundation

public typealias MessageBroadcaster<Message> = PassthroughSubject<Message, Never>
