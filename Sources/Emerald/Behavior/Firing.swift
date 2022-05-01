//
//  Firing.swift
//  Emerald
//
//  Created by Cristian Diaz on 25.4.2022.
//

import Beryllium
import Combine
import Foundation
import SpriteKit

public protocol Chargeable: AnyObject {
    
    var charge: Double { get set }
    
    var chargeInterval: TimeInterval { get }
    var chargeAmount: Double { get }
    var chargeCap: Double { get }
}

public protocol Fireable: Node {
    
    associatedtype Load: Chargeable
    
    var vectorThresholdToInvalidateFire: Vector? { get }
    
    func load() -> Load?
    func fire(load: Load, toward direction: Vector)
    func unload(load: Load)
    
    func onCharged(toLevel level: Double)
}

public class Firing<T: Fireable>: NodeBehavior<T> {
    
    public override func start() {
        super.start()
        
        node.isUserInteractionEnabled = true
        
        stateMachine.start()
    }
    
    public override func stop() {
        super.stop()
        
        stateMachine.stop()
    }
    
    public override func subscribe(_ subscriptions: inout Set<AnyCancellable>) {
        node.uponTouchBegan
            .sink { [unowned self] _ in
                stateMachine.sendEvent(.charge)
            }
            .store(in: &subscriptions)
        
//        if let squaredDistanceToInvalidateFire =
//            node.vectorThresholdToInvalidateFire?.distanceSquared(to: .zero) {
//            node.uponTouchMoved
//                .sink { [unowned stateMachine] _ in
//                    stateMachine.sendEvent(.cancel)
//                }
//                .store(in: &subscriptions)
//        }
        
        node.uponTouchEnded
            .sink { [unowned stateMachine] _ in
                stateMachine.sendEvent(.fire)
            }
            .store(in: &subscriptions)
    }
    
    // MARK: - Private
    
    private enum State {

        case idle, charging
    }

    private enum Event: String {
        
        case charge, fire, cancel
    }
    
    private lazy var stateMachine = EventDrivenFSM<State, Event>(initialState: .idle).configure {
        $0.addState(.idle) { [unowned self] in
            charger = nil
        }
        .onEvent(.charge) { [unowned self] in
            load = node.load()
            return .charging
        }
    
        $0.addState(.charging) { [unowned self] in
            charger = Charger(chargeable: load)
            charger?.start()
        } onExit: { [unowned self] in
            charger = nil
        }
        .onEvent(.fire) { [unowned self] in
            if let load = load {
                node.fire(load: load, toward: .zero)
            }
            
            return .idle
        }
        .onEvent(.cancel) { .idle }
    }

    private var load: T.Load?
    private var charger: Charger?
}

private class Charger: Runnable {
    
    private(set) var isRunning = false
    
    init?(chargeable: Chargeable?) {
        guard let chargeable = chargeable else {
            return nil
        }

        self.chargeable = chargeable
    }
    
    deinit {
        print("ditched Charger")
    }
    
    func start() {
        guard !isRunning else {
            return
        }
        
        defer {
            isRunning = true
        }
        
        subscription = stride(
            from: chargeable.chargeAmount,
            through: chargeable.chargeCap,
            by: chargeable.chargeAmount
        )
        .publisher
        .flatMap(maxPublishers: .max(1)) { [unowned self] in
            Just($0).delay(for: .seconds(chargeable.chargeInterval), scheduler: RunLoop.main)
        }
        .sink { _ in
            print("Done charging!")
        } receiveValue: { [unowned self] in
            chargeable.charge = $0
            print("charging... \($0)")
        }
    }
    
    func stop() {
        guard isRunning else {
            return
        }
        
        subscription?.cancel()
        
        isRunning = false
    }
    
    // MARK: - Private
    
    private let chargeable: Chargeable
    
    private var subscription: AnyCancellable?
}
