//
//  GesturePublishers.swift
//  Emerald
//
//  Created by Cristian Diaz on 9.5.2022.
//

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
                $0.location.distance(to: $1.location) < maxOffset &&
                contains($1.location)
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
                    direction: $0.location.direction(toward: $1.location),
                    magnitude: $0.location.distance(to: $1.location)
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
                let currentLocation = $1.location(in: self)
                
                return $0.location.distance(to: currentLocation) < maxOffset
                    && contains(currentLocation)
            }
            .map { $0.0 }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Private
    
    private var maxOffset: CGFloat { 15 }
    private var tapTimeout: TimeInterval { 0.35 }
    private var swipeTimeout: TimeInterval { 0.35 }
    private var swipeDistanceThreshold: CGFloat { 20 }
    private var longPressThreshold: TimeInterval { 0.75 }
}
