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

open class DragBoard: Board {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
//        longPressPublisher
//            .compactMap { [unowned self] _ in pick?.token }
//            .filter { $0.supportsOptions }
//            .sink { [unowned self] token in
//                cancel()
//                token.showOptions()
//            }
//            .store(in: &subscriptions)
    }
    
    public func bridge(_ other: DragBoard) {
        super.bridge(other)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard
            let touch = touches.first,
            let space = space(at: touch.location(in: self)),
            let token = space.pickToken(at: touch.location(in: space)) as? AnyToken & Draggable
        else {
            return
        }

        with(token) {
            $0.move(toParent: self)
            $0.zPosition = 100
            $0.setSelected(true)
        }
        
        pick = Pick(token: token, offset: touch.location(in: space), space: space)

        setSpacesHighlighted(true) {
            $0 != space && token.canBeUsedOn(space: $0)
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard
            let pick = pick,
            let location = touches.first?.location(in: self)
        else {
            return
        }

        pick.token.drag(to: location - pick.offset)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        guard
            let location = touches.first?.location(in: self),
            let pick = pick
        else {
            return
        }
        
        play(token: pick.token, at: location, elseReturnTo: pick.space)
        
        setSpacesHighlighted(false)
        
        if !pick.token.isInvalidated {
            pick.token.setSelected(false)
        }
        
        self.pick = nil
    }
    
    // MARK: - Internal
    
    override func cancelMove() {
        guard let pick = pick else {
            return
        }
        
        pick.space.place(token: pick.token)
        
        setSpacesHighlighted(false)
        
        self.pick = nil
    }
    
    // MARK: - Private
    
    private typealias Pick = (token: AnyToken & Draggable, offset: CGPoint, space: AnySpace)
    
    private var pick: Pick?

    private var subscriptions = Set<AnyCancellable>()
}
