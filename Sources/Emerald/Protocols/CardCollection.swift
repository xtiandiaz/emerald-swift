//
//  CardCollection.swift
//  Emerald
//
//  Created by Cristian Diaz on 12.5.2022.
//

import Beryllium
import Foundation

public protocol CardCollection: Configurable, Collection where Element == Card {
    
    var capacity: Int? { get }
    
    func allows(_ card: Element) -> Bool
}
