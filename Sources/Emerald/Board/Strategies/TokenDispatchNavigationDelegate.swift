//
//  TokenDispatchNavigationDelegate.swift
//  Emerald
//
//  Created by Cristian Diaz on 24.10.2022.
//

import Foundation

public protocol TokenDispatchNavigationDelegate<SpaceType>: TokenNavigationDelegate {
    
    func isValidDestination(
        _ destination: SpaceType,
        forToken token: SpaceType.TokenType,
        fromSpace origin: SpaceType
    ) -> Bool
}
