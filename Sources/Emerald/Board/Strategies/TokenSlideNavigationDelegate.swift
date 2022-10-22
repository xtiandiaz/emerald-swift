//
//  TokenSlideNavigationDelegate.swift
//  Emerald
//
//  Created by Cristian Diaz on 22.10.2022.
//

import Foundation

public protocol TokenSlideNavigationDelegate<SpaceType>: AnyObject {
    
    associatedtype SpaceType: Space & Place
    
    func tokenFromSpace(_ space: SpaceType) -> SpaceType.TokenType?
}
