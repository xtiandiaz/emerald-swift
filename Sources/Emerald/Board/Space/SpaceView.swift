//
//  SpaceView.swift
//  Emerald
//
//  Created by Cristian Diaz on 7.7.2022.
//

import Foundation
import SwiftUI

public protocol CollectionSpaceView: View {
    
    associatedtype Model: CollectionSpace
    
    var space: Model { get }
    
    init(space: Model)
}
