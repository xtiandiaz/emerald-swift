//
//  Node.swift
//  Emerald
//
//  Created by Cristian Díaz on 4.9.2021.
//

import Combine
import Foundation
import SpriteKit

open class Node: SKNode {
    
    public let id = UUID()
    
    public private(set) var isInvalidated = false
    
    public private(set) lazy var touchBeganPublisher: AnyPublisher<UITouch, Never> = touchBeganSubject
        .share()
        .eraseToAnyPublisher()
    
    public private(set) lazy var touchMovedPublisher: AnyPublisher<UITouch, Never> = touchMovedSubject
        .share()
        .eraseToAnyPublisher()
    
    public private(set) lazy var touchEndedPublisher: AnyPublisher<UITouch, Never> = touchEndedSubject
        .share()
        .eraseToAnyPublisher()
    
    public var width: CGFloat {
        frame.width
    }
    
    public var height: CGFloat {
        frame.height
    }
    
    public var size: CGSize {
        frame.size
    }
    
    public override init() {
        super.init()
    }
    
    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func invalidate() {
        isInvalidated = true
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            latestTouchLocation = touch.location(in: self)
            touchBeganSubject.send(touch)
        }
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, touch.phase == .moved else {
            return
        }
        
        let location = touch.location(in: self)
        
        if latestTouchLocation != location {
            latestTouchLocation = location
            touchMovedSubject.send(touch)
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            latestTouchLocation = touch.location(in: self)
            touchEndedSubject.send(touch)
        }
    }
    
    public func runIfValid(_ action: SKAction, withKey key: String) {
        if !isInvalidated {
            run(action, withKey: key)
        }
    }
    
    // MARK: - Private
    
    private var latestTouchLocation: CGPoint?
    
    private lazy var touchBeganSubject = PassthroughSubject<UITouch, Never>()
    private lazy var touchMovedSubject = PassthroughSubject<UITouch, Never>()
    private lazy var touchEndedSubject = PassthroughSubject<UITouch, Never>()
}

func != (lhs: Node, rhs: Node) -> Bool {
    lhs.id != rhs.id
}
