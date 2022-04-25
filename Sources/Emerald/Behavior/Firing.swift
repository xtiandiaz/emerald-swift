//
//  Firing.swift
//  Emerald
//
//  Created by Cristian Diaz on 25.4.2022.
//

import Combine
import Foundation
import SpriteKit

public protocol Fireable: Node {
    
    var canFire: Bool { get }
    var vectorThresholdToInvalidateFire: Vector? { get }
    var chargeTime: TimeInterval { get }
    
    func charge()
    func fire(toward direction: Vector)
    func cancel()
}

public class Firing<T: Fireable>: NodeBehavior<T> {
    
    deinit {
        cancel()
    }
    
    public override func start() {
        super.start()
        
        node.isUserInteractionEnabled = true
    }
    
    public override func subscribe(_ subscriptions: inout Set<AnyCancellable>) {
        node.uponTouchesBegan
            .sink { [unowned self] in
                if node.canFire, let location = $0.first?.location(in: node) {
                    chargeOffset = node.position - location
                    charge()
                }
            }
            .store(in: &subscriptions)
        
        if let squaredDistanceToInvalidateFire = node.vectorThresholdToInvalidateFire?
            .distanceSquared(to: .zero) {
            node.uponTouchesMoved
                .sink { [unowned self] in
                    if state != .idle,
                       let location = $0.first?.location(in: node),
                       node.position.distanceSquared(to: location + chargeOffset) > squaredDistanceToInvalidateFire {
                        cancel()
                    }
                }
                .store(in: &subscriptions)
        }
        
        node.uponTouchesEnded
            .sink { [unowned self] in
                if let touch = $0.first {
                    switch state {
                    case .charged:
                        node.fire(
                            toward: node.position.direction(toward: touch.location(in: node) + chargeOffset)
                        )
                        
                    case .charging:
                        cancel()
                        
                    default:
                        break
                    }
                }
            }
            .store(in: &subscriptions)
    }
    
    public func cancel() {
        guard state != .idle else {
            return
        }
        
        chargeTimer?.invalidate()
        node.cancel()
        
        state = .idle
    }
    
    // MARK: - Private
    
    private enum State {
        
        case idle,
             charging,
             charged
    }
    
    private var state: State = .idle
    private var chargeTimer: Timer?
    private var chargeOffset: CGPoint = .zero
    
    private func charge() {
        state = .charging
        
        node.charge()
        
        chargeTimer = .scheduledTimer(withTimeInterval: node.chargeTime, repeats: false) {
            [weak self] _ in
            self?.state = .charged
        }
    }
}
