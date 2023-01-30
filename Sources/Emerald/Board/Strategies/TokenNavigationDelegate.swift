//
//  TokenNavigationDelegate.swift
//  Emerald
//
//  Created by Cristian Diaz on 24.10.2022.
//

import Foundation

public protocol TokenNavigationDelegate<SpaceType>: AnyObject {
    
    associatedtype SpaceType: Space & Place
    
    func tokenFromSpace(_ space: SpaceType) -> SpaceType.TokenType?
    
    func resolveTokenOverlap(
        betweenSource source: SpaceType.TokenType,
        andTarget target: SpaceType.TokenType
    ) -> SpaceType.TokenType?
    
    func moveToken(
        _ token: SpaceType.TokenType,
        intoSpace destination: SpaceType,
        onCompleted: @escaping () -> Void
    )
    
    func disposeOfToken(_ token: SpaceType.TokenType)
}
