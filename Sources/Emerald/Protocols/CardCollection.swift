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
    
    func remove(_ element: Element) -> Element?
    func remove(at index: Int) -> Element?
    func firstIndex(of element: Element) -> Int?
}
