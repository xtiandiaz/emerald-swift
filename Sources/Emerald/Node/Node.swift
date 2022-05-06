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
    
    public private(set) lazy var uponTouchesBegan: AnyPublisher<Set<UITouch>, Never> = touchesBeganSubject
        .share()
        .eraseToAnyPublisher()
    
    public private(set) lazy var uponTouchesMoved: AnyPublisher<Set<UITouch>, Never> = touchesMovedSubject
        .share()
        .eraseToAnyPublisher()
    
    public private(set) lazy var uponTouchesEnded: AnyPublisher<Set<UITouch>, Never> = touchesEndedSubject
        .share()
        .eraseToAnyPublisher()
    
    public var uponTouchBegan: AnyPublisher<UITouch, Never> {
        uponTouchesBegan.compactMap { $0.first }.eraseToAnyPublisher()
    }
    
    public var uponTouchMoved: AnyPublisher<UITouch, Never> {
        uponTouchesMoved.compactMap { $0.first }.eraseToAnyPublisher()
    }
    
    public var uponTouchEnded: AnyPublisher<UITouch, Never> {
        uponTouchesEnded.compactMap { $0.first }.eraseToAnyPublisher()
    }
    
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
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesBeganSubject.send(touches)
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesMovedSubject.send(touches)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEndedSubject.send(touches)
    }
    
    // MARK: - Private
    
    private let touchesBeganSubject = PassthroughSubject<Set<UITouch>, Never>()
    private let touchesMovedSubject = PassthroughSubject<Set<UITouch>, Never>()
    private let touchesEndedSubject = PassthroughSubject<Set<UITouch>, Never>()
}
