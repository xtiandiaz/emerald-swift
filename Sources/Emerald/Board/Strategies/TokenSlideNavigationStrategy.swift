//
//  TokenSlideNavigationStrategy.swift
//  Emerald
//
//  Created by Cristian Diaz on 22.10.2022.
//

import Beryllium
import Foundation

public class TokenSlideNavigationStrategy<
    SpaceType: Space & Place,
    Delegate: TokenSlideNavigationDelegate<SpaceType> & AnyObject
>: TokenNavigationStrategy {
    
    public weak var delegate: Delegate?
    
    public required init(map: GridMap<SpaceType>) {
        self.map = map
    }
    
    public func slideToken(
        atLocalPosition localPosition: Position,
        towardDirection direction: Direction
    ) {
        guard
            let delegate,
            let space = map.place(forLocalPosition: localPosition),
            let token = delegate.tokenFromSpace(space),
            let nextSpace = nextSpaceForToken(token, fromSpace: space, towardDirection: direction),
            nextSpace != space
        else {
            return
        }
        
        space.releaseToken(token)
        
        let resultToken: SpaceType.TokenType?
        let disposing: (() -> Void)?
        
        if let otherToken = nextSpace.peek() {
            nextSpace.releaseToken(otherToken)
            
            resultToken = delegate.resolveTokenOverlap(betweenSource: token, andTarget: otherToken)
            disposing = {
                if token.isInvalidated {
                    delegate.disposeOfToken(token)
                }
                if otherToken.isInvalidated {
                    delegate.disposeOfToken(otherToken)
                }
            }
        } else {
            resultToken = token
            disposing = nil
        }
        
        if let resultToken, !resultToken.isInvalidated {
            delegate.moveToken(resultToken, intoSpace: nextSpace) {
                disposing?()
            }
        }
    }
    
    // MARK: - Private
    
    private let map: GridMap<SpaceType>
    
    private func nextSpaceForToken(
        _ token: SpaceType.TokenType,
        fromSpace currentSpace: SpaceType,
        towardDirection direction: Direction,
        steps: Int = 0
    ) -> SpaceType? {
        guard let delegate else {
            return nil
        }
        
        if delegate.shouldLeaveToken(token, inSpace: currentSpace), steps > 0 {
            return currentSpace
        }
        
        let nextSpace = map.nextPlace(fromLocation: currentSpace.location, toward: direction)
        
        if
            delegate.shouldSlideToken(token, intoSpace: nextSpace),
            let nextSpace
        {
            return nextSpaceForToken(
                token,
                fromSpace: nextSpace,
                towardDirection: direction,
                steps: steps + 1
            )
        }
        
        return currentSpace
    }
}
