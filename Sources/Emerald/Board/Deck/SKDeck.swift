//
//  SKDeck.swift
//  Emerald
//
//  Created by Cristian Diaz on 16.5.2022.
//

import Foundation
import UIKit

public struct DeckCard<T> {
    
    public let type: T
    public let value: Int
    
    public init(type: T, value: Int) {
        self.type = type
        self.value = value
    }
}

open class SKDeck<T: SKCard> {
    
    open func take(count: Int) -> [T] {
        fatalError("Not implemented")
    }
    
    // MARK: - Public
    
    public enum DealMode {
        
        case clustered,
             interlaced
    }
    
    public init() {
    }
    
    public static func deal(
        card: T,
        facing side: FlipSide,
        into space: SKSpace<T>,
        fromOrigin origin: Anchor
    ) {
        deal(
            card: card,
            facing: side,
            into: space,
            fromPosition: origin.point(in: UIScreen.main.bounds)
        )
    }
    
    public static func deal(
        card: T,
        facing side: FlipSide,
        into space: SKSpace<T>,
        fromPosition position: CGPoint
    ) {
        card.position = position
        card.flipOver(side: side, toward: .right, animated: false)
        
        space.place(token: card)
    }
    
    public func takeOne() -> T? {
        let unitArray = take(count: 1)
        return unitArray.isEmpty ? nil : unitArray[0]
    }
    
    @MainActor
    public func deal(
        count: Int?,
        facing side: FlipSide,
        into spaces: [SKSpace<T>],
        withOrigin origin: Anchor,
        mode: DealMode = .clustered
    ) async {
        let origin = origin.point(in: UIScreen.main.bounds)
        let count = { (space: SKSpace<T>) -> Int in
            min(count ?? .max, space.tokenCapacity - space.tokenCount)
        }
        
        switch mode {
        case .clustered:
            for space in spaces {
                for card in take(count: count(space)) {
                    
                    Self.deal(card: card, facing: side, into: space, fromPosition: origin)
                    
                    await Task.sleep(seconds: 0.1)
                }
            }
        
        case .interlaced:
            typealias Fill = (count: Int, space: SKSpace<T>)
            
            var fills = spaces.map {
                Fill(count($0), $0)
            }
            
            while !(fills.allSatisfy { $0.count == 0 }) {
                for i in fills.indices {
                    guard fills[i].count != 0, let card = takeOne() else {
                        continue
                    }
                    
                    Self.deal(card: card, facing: side, into: fills[i].space, fromPosition: origin)
                    
                    fills[i].count -= 1
                    
                    await Task.sleep(seconds: 0.1)
                }
            }
        }
    }
}
