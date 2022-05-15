//
//  DragBoard.swift
//  Emerald
//
//  Created by Cristian Diaz on 14.5.2022.
//

import Foundation
import SpriteKit

open class DragBoard: Node, Board {
    
    private(set) public var spaces = [Space]()
    
    public var isLocked: Bool {
        get { !isUserInteractionEnabled }
        set { isUserInteractionEnabled = !newValue }
    }
    
    public override init() {
        super.init()
        
        isLocked = false
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
        guard
            let touch = touches.first,
            let space = space(at: touch.location(in: self)),
            let token = space.pickToken(at: touch.location(in: space))
        else {
            return
        }

        token.move(toParent: self)
        
        pick = (token: token, offset: touch.location(in: space), space: space)

        setSpacesHighlighted(true, for: pick!)
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard
            let pick = pick,
            let location = touches.first?.location(in: self)
        else {
            return
        }

        pick.token.position = location - pick.offset
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
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
        
        self.pick = nil
    }
    
    // MARK: - Private

    private typealias Pick = (token: Token, offset: CGPoint, space: Space)

    private var pick: Pick?
    private var bridgedBoards = [DragBoard]()
    
    private func space(for token: Token, at location: CGPoint) -> Space? {
        if let space = space(at: location), space.accepts(token: token) {
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
            space.setHighlighted(space.accepts(token: pick.token) && highlighted)
        }
        
        spaces.filter { $0 != pick.space }.forEach(setHighlighted)
        
        bridgedBoards.flatMap { $0.spaces }.forEach(setHighlighted)
    }
}
