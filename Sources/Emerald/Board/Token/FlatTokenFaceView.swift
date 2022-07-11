//
//  FlatTokenFaceView.swift
//  Emerald
//
//  Created by Cristian Diaz on 11.7.2022.
//

import Foundation
import SwiftUI

public protocol FlatTokenFaceView: View {
    
    associatedtype Model: FlatTokenFace
    
    var face: Model { get }
}
