//
//  Gradient.swift
//  Emerald
//
//  Created by Cristian Díaz on 5.9.2021.
//

import UIKit

public struct Gradient {
    
    let colors: [UIColor]
    let locations: [Double]
    let start: Anchor
    let end: Anchor
    
    public init(colors: [UIColor], locations: [Double], start: Anchor, end: Anchor) {
        self.colors = colors
        self.locations = locations
        self.start = start
        self.end = end
    }
}
