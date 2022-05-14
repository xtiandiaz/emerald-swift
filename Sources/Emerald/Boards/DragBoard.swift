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
        guard !contains(space: space) else {
            return
        }
        
        spaces.append(space)
        
        addChild(space)
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

        setSpacesHighlighted(true)
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
        } else {
            pick.space.place(token: pick.token)
        }
        
        setSpacesHighlighted(false)
        
        self.pick = nil
    }
    
    // MARK: - Private

    private typealias Pick = (token: Token, offset: CGPoint, space: Space)

    private var pick: Pick?
    
    private func space(for token: Token, at location: CGPoint) -> Space? {
        if let space = space(at: location), space.accepts(token: token) {
            return space
        }
        
        return nil
    }
    
    private func space(at location: CGPoint) -> Space? {
        spaces.first { $0.contains(location) }
    }
    
    private func setSpacesHighlighted(_ highlighted: Bool) {
        guard let pick = pick else {
            return
        }
        
        spaces
            .filter { $0 != pick.space }
            .forEach {
                $0.setHighlighted($0.accepts(token: pick.token) && highlighted)
            }
    }
}
