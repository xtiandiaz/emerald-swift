//
//  Selectable.swift
//  Emerald
//
//  Created by Cristian Diaz on 24.5.2022.
//

import Foundation

public protocol Selectable {
    
    var isSelected: Bool { get }
    
    func setSelected(_ selected: Bool)
}
