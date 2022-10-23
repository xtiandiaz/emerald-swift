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
    
    public func slideToken(atLocalPosition localPosition: Position, toward direction: Direction) {
        guard
            let space = map.place(forLocalPosition: localPosition),
            let token = delegate?.tokenFromSpace(space),
            let nextSpace = nextSpaceForToken(token, fromSpace: space, towardDirection: direction),
            nextSpace != space
        else {
            return
        }
        
        space.release(token: token)
        nextSpace.place(token: token)
    }
    
    // MARK: - Private
    
    private let map: GridMap<SpaceType>
    
    private func nextSpaceForToken(
        _ token: SpaceType.TokenType,
        fromSpace currentSpace: SpaceType,
        towardDirection direction: Direction
    ) -> SpaceType? {
        guard let delegate else {
            return nil
        }
        
        let nextSpace = map.nextPlace(fromLocation: currentSpace.location, toward: direction)
        
        if
            delegate.shouldKeepSlidingToken(token, atSpace: currentSpace, intoSpace: nextSpace),
            let nextSpace
        {
            return nextSpaceForToken(token, fromSpace: nextSpace, towardDirection: direction)
        }
        
        return currentSpace
    }
}
