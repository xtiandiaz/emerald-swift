//
//  FlatTokenFace.swift
//  Emerald
//
//  Created by Cristian Diaz on 6.7.2022.
//

import Foundation
import SwiftUI

public protocol FlatTokenFace: Identifiable {
    
    var side: FlatTokenSide { get }
    var value: Int { get }
}
