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

public enum ChargeableMode {
    
    case atIntervals(duration: TimeInterval, amount: Double),
         dragging(axis: Axis, step: Double, amount: Double)
}

public protocol Chargeable: Node {
    
    var charge: Double { get set }
    var chargeCap: Double { get }
    var chargingMode: ChargeableMode { get }
}

public protocol Fireable: Node {
    
    associatedtype Load: Chargeable
    
    var loadDelay: TimeInterval { get }
    
    func load() -> Load?
    func fire(load: Load, toward direction: Vector)
    func cancel(load: Load?)
    
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
    
    public func cancel() {
        if !isCancelled {
            stateMachine.sendEvent(.cancel)
        }
        
        isCancelled = true
    }
    
    // MARK: - Internal
    
    override func subscribe(_ subscriptions: inout Set<AnyCancellable>) {
        node.uponTouchBegan
            .debounce(for: .seconds(node.loadDelay), scheduler: RunLoop.main)
            .sink { [unowned self] _ in
                if !isCancelled {
                    stateMachine.sendEvent(.charge)
                }
            }
            .store(in: &subscriptions)
        
        node.uponTouchEnded
            .sink { [unowned self] _ in
                if !isCancelled {
                    stateMachine.sendEvent(.fire)
                }
                
                isCancelled = false
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
    
    private var load: T.Load?
    private var charger: Charger?
    private var isCancelled = false
    
    private lazy var stateMachine = EventDrivenFSM<State, Event>(initialState: .idle).configure {
        $0.addState(.idle) { [unowned self] in
            load = nil
            charger = nil
        }
        .onEvent(.charge) { [unowned self] in
            if let load = node.load() {
                self.load = load
                return .charging
            }
            
            return .idle
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
        .onEvent(.cancel) { [unowned self] in
            node.cancel(load: load)
            
            return .idle
        }
    }
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
        
        startWithMode()
        
        isRunning = true
    }
    
    func update() {
        switch chargeable.chargingMode {
        case .dragging(let axis, let step, let amount):
            break
            
        default:
            break
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
    private var startPosition: CGPoint = .zero
    
    private func startWithMode() {
        switch chargeable.chargingMode {
        case .atIntervals(let duration, let amount):
            subscription = stride(from: amount, through: chargeable.chargeCap, by: amount)
                .publisher
                .flatMap(maxPublishers: .max(1)) {
                    Just($0).delay(for: .seconds(duration), scheduler: RunLoop.main)
                }
                .sink { _ in
                    print("Done charging!")
                } receiveValue: { [unowned self] in
                    chargeable.charge = $0
                    print("charging... \($0)")
                }
            
        case .dragging:
            startPosition = chargeable.position
        }
    }
}
