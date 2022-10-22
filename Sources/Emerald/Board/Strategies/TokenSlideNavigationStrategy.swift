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
    
    public func nextLocationForTokenAtSpace(
        _ space: SpaceType,
        toward direction: Direction
    ) -> Location? {
        guard let token = delegate?.tokenFromSpace(space) else {
            return nil
        }
        
        return .zero
//        return nextSpaceForToken(token, at: space.location, toward: direction)?.location
    }
    
    // MARK: - Private
    
    private let map: GridMap<SpaceType>
    
    private func nextSpaceForToken(
        _ token: SpaceType.TokenType,
        at origin: Location,
        toward direction: Direction
    ) -> SpaceType? {
        return nil
    }
}
