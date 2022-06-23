//
//  Deck.swift
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

open class Deck<T: Card> {
    
    open func takeOne() -> T {
        take(count: 1)[0]
    }
    
    open func take(count: Int) -> [T] {
        fatalError()
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
        facing side: CardSide,
        into space: Space<T>,
        fromPosition origin: CGPoint
    ) {
        card.position = origin
        card.flip(toSide: side, toward: .right, animated: false)
        
        space.place(token: card)
        
    }
    
    @MainActor
    public func deal(
        count: Int?,
        facing side: CardSide,
        into spaces: [Space<T>],
        withOrigin origin: Anchor,
        mode: DealMode = .clustered
    ) async {
        let origin = origin.point(in: UIScreen.main.bounds)
        let count = { (space: Space<T>) -> Int in
            min(count ?? .max, space.tokenCapacity - space.tokenCount)
        }
        
        switch mode {
        case .clustered:
            for space in spaces {
                for card in take(count: count(space)) {
                    
                    Self.deal(card: card, facing: side, into: space, fromPosition: origin)
                    
                    try! await Task.sleep(seconds: 0.1)
                }
            }
        
        case .interlaced:
            typealias Fill = (count: Int, space: Space<T>)
            
            var fills = spaces.map {
                Fill(count($0), $0)
            }
            
            while !(fills.allSatisfy { $0.count == 0 }) {
                for i in fills.indices {
                    if fills[i].count == 0 {
                        continue
                    }
                    
                    Self.deal(card: takeOne(), facing: side, into: fills[i].space, fromPosition: origin)
                    
                    fills[i].count -= 1
                    
                    try! await Task.sleep(seconds: 0.1)
                }
            }
        }
    }
    
    public func deal(count: Int, into spaces: [Space<T>]) {
        zip(spaces, (0..<spaces.count).map { _ in take(count: count) }).forEach { space, cards in
            cards.forEach {
                space.place(token: $0)
            }
        }
    }
}
