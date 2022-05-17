//
//  DragBoard.swift
//  Emerald
//
//  Created by Cristian Diaz on 14.5.2022.
//

import Beryllium
import Combine
import Foundation
import SpriteKit

open class DragBoard: Node, Board {
    
    private(set) public var spaces = [Space]()
    
    public var isLocked: Bool {
        get { !isUserInteractionEnabled }
        set { isUserInteractionEnabled = !newValue }
    }
    
    public override var frame: CGRect {
        _frame
    }
    
    public init(frame: CGRect) {
        _frame = frame
        
        super.init()
        
        isLocked = false
        
        longPressPublisher
            .compactMap { [unowned self] _ in pick?.token }
            .filter { $0.supportsOptions }
            .sink { [unowned self] token in
                cancel()
                token.showOptions()
            }
            .store(in: &subscriptions)
    }
    
    public func addSpace(_ space: Space) {
        if !spaces.contains(space) {
            spaces.append(space)
            addChild(space)
        }
    }
    
    public func bridge(_ other: DragBoard) {
        if !bridgedBoards.contains(other), other != self {
            bridgedBoards.append(other)
            other.bridge(self)
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard
            let touch = touches.first,
            let space = space(at: touch.location(in: self)),
            let token = space.pickToken(at: touch.location(in: space))
        else {
            return
        }
        
        with(token) {
            $0.move(toParent: self)
            $0.zPosition = 100
            $0.setSelected(true)
        }
        
        pick = (token: token, offset: touch.location(in: space), space: space)

        setSpacesHighlighted(true, for: pick!)
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard
            let pick = pick,
            let location = touches.first?.location(in: self)
        else {
            return
        }

        pick.token.position = location - pick.offset
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        guard
            let location = touches.first?.location(in: self),
            let pick = pick
        else {
            return
        }
        
        if let destination = space(for: pick.token, at: location) {
            destination.place(token: pick.token)
        } else if let bridgedDestination = bridgedSpace(for: pick.token, at: location) {
            bridgedDestination.place(token: pick.token)
        } else {
            pick.space.place(token: pick.token)
        }
        
        setSpacesHighlighted(false, for: pick)
        
        pick.token.setSelected(false)
        pick.space.arrange()
        
        self.pick = nil
    }
    
    public func setVisible(_ visible: Bool, withColor color: UIColor) {
        if !visible {
            debugNode.removeFromParent()
        } else if debugNode.parent.isNil {
            addChild(debugNode.configure {
                $0.fillColor = color
            })
        }
    }
    
    // MARK: - Private

    private typealias Pick = (token: Token, offset: CGPoint, space: Space)
    
    private let _frame: CGRect

    private var pick: Pick?
    private var bridgedBoards = [DragBoard]()
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var debugNode = SKShapeNode(rect: frame)
    
    private func space(for token: Token, at location: CGPoint) -> Space? {
        if let space = space(at: location), space.canPlace(token: token) {
            return space
        }
        
        return nil
    }
    
    private func space(at location: CGPoint) -> Space? {
        spaces.first { $0.contains(location) }
    }
    
    private func bridgedSpace(for token: Token, at location: CGPoint) -> Space? {
        bridgedBoards.compactMap {
            $0.space(for: token, at: $0.convert(location, from: self))
        }
        .first
    }
    
    private func setSpacesHighlighted(_ highlighted: Bool, for pick: Pick) {
        let setHighlighted = { (space: Space) -> Void in
            space.setHighlighted(space.canPlace(token: pick.token) && highlighted)
        }
        
        spaces.filter { $0 != pick.space }.forEach(setHighlighted)
        
        bridgedBoards.flatMap { $0.spaces }.forEach(setHighlighted)
    }
    
    private func cancel() {
        guard let pick = pick else {
            return
        }
        
        pick.space.place(token: pick.token)
        
        setSpacesHighlighted(false, for: pick)
        
        self.pick = nil
    }
}
