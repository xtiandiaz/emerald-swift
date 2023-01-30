//
//  GesturePublishers.swift
//  Emerald
//
//  Created by Cristian Diaz on 9.5.2022.
//

import Beryllium
import Combine
import Foundation
import SpriteKit

public struct SwipeInfo {
    
    public let direction: Direction
    public let magnitude: CGFloat
    
    // MARK: - Internal
    
    init?(direction: Direction?, magnitude: CGFloat) {
        guard let direction = direction else {
            return nil
        }
        
        self.direction = direction
        self.magnitude = magnitude
    }
}

extension Node {
    
    public var tapGesturePublisher: AnyPublisher<TouchInfo, Never> {
        Publishers.Zip(
            touchBeganPublisher.map { [unowned self] in $0.info(forNode: self) },
            touchEndedPublisher.map { [unowned self] in $0.info(forNode: self) }
        )
            .filter { [unowned self] in
                ($1.timestamp - $0.timestamp) < tapTimeout &&
                $0.position.distance(to: $1.position) < maxOffset &&
                contains($1.position)
            }
            .map { $0.0 }
            .eraseToAnyPublisher()
    }
    
    public var swipeGesturePublisher: AnyPublisher<SwipeInfo, Never> {
        Publishers.Zip(
            touchBeganPublisher.map { [unowned self] in $0.info(forNode: self) },
            touchEndedPublisher.map { [unowned self] in $0.info(forNode: self) }
        )
            .filter { [swipeTimeout] in ($1.timestamp - $0.timestamp) < swipeTimeout }
            .compactMap {
                SwipeInfo(
                    direction: $0.position.direction(toward: $1.position),
                    magnitude: $0.position.distance(to: $1.position)
                )
            }
            .filter { [swipeDistanceThreshold] in $0.magnitude > swipeDistanceThreshold }
            .eraseToAnyPublisher()
    }
    
    public var pressPublisher: AnyPublisher<TouchInfo, Never> {
        touchBeganPublisher
            .map { [unowned self] in $0.info(forNode: self) }
            .eraseToAnyPublisher()
    }
    
    public var longPressPublisher: AnyPublisher<TouchInfo, Never> {
        touchBeganPublisher
            .map { [unowned self] in ($0.info(forNode: self), $0) }
            .debounce(for: .seconds(longPressThreshold), scheduler: RunLoop.main)
            .filter {
                switch $1.phase {
                case .ended, .cancelled, .regionExited: return false
                default: return true
                }
            }
            .filter { [unowned self] in
                $0.position.distance(to: $1.location(in: self)) < maxOffset
            }
            .map { $0.0 }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Private
    
    private var maxOffset: CGFloat { 10 }
    private var tapTimeout: TimeInterval { 0.35 }
    private var swipeTimeout: TimeInterval { 0.35 }
    private var swipeDistanceThreshold: CGFloat { 20 }
    private var longPressThreshold: TimeInterval { 0.5 }
}
