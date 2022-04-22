//
//  FireableNode.swift
//  Emerald
//
//  Created by Cristian Diaz on 21.4.2022.
//

import Combine
import Foundation
import SpriteKit

public protocol FireableNode: Node {
    
    associatedtype Shot
    
    var chargeTime: TimeInterval { get }
    var vectorThresholdToInvalidateFire: Vector2 { get }
    
    var onFired: AnyPublisher<Shot, Never> { get }
    
    func charge()
    func fire()
    func cancel()
}

extension FireableNode {
    
    public var squareThresholdToInvalidateFire: CGFloat {
        vectorThresholdToInvalidateFire.distanceSquared(to: .zero)
    }
    
    public func timer() -> Timer {
        Timer.scheduledTimer(withTimeInterval: chargeTime, repeats: false) { [weak self] _ in
            self?.fire()
        }
    }
}
