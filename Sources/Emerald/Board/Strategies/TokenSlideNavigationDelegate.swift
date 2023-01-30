//
//  TokenSlideNavigationDelegate.swift
//  Emerald
//
//  Created by Cristian Diaz on 22.10.2022.
//

import Foundation

public protocol TokenSlideNavigationDelegate<SpaceType>: TokenNavigationDelegate {
    
    func shouldSlideToken(_ token: SpaceType.TokenType, intoSpace nextSpace: SpaceType?) -> Bool
    func shouldLeaveToken(_ token: SpaceType.TokenType, inSpace currentSpace: SpaceType) -> Bool
}
