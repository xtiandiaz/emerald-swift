//
//  TokenSelectionDelegate.swift
//  Emerald
//
//  Created by Cristian Diaz on 19.10.2022.
//

import Foundation

public protocol TokenSelectionDelegate<SpaceType>: AnyObject {
    
    associatedtype SpaceType: Space & Place
    
    func didSelectSpace(_ space: SpaceType)
    func didFinishSelectingInSpaces(_ spaces: [SpaceType])
}
