//
//  Card.swift
//  Emerald
//
//  Created by Cristian Diaz on 6.7.2022.
//

import Foundation
import SwiftUI

public protocol Card: Token {
    
    associatedtype FaceType: CardFace
    
    var front: FaceType { get }
    var back: FaceType? { get }
    
    var side: FlipSide { get set }
}
