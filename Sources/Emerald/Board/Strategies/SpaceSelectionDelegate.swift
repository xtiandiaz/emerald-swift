//
//  SpaceSelectionDelegate.swift
//  Emerald
//
//  Created by Cristian Diaz on 19.10.2022.
//

import Foundation

public protocol SpaceSelectionDelegate<SpaceType>: AnyObject {
    
    associatedtype SpaceType: Space & Place
    
    func shouldSelectSpace(_ space: SpaceType, after latest: SpaceType) -> Bool
    func didFinishSelectingSpaces(_ spaces: [SpaceType])
}
