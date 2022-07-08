//
//  CardFace.swift
//  Emerald
//
//  Created by Cristian Diaz on 6.7.2022.
//

import Foundation
import SwiftUI

public protocol CardFace: Identifiable {
    
    associatedtype CardType
    
    var side: FlipSide { get }
    var type: CardType { get }
    var value: Int { get }
}

public protocol CardFaceView: View {
    
    associatedtype Model: CardFace
    
    var face: Model { get }
}
