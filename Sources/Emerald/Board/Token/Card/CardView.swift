//
//  CardView.swift
//  Emerald
//
//  Created by Cristian Diaz on 7.7.2022.
//

import Foundation
import SwiftUI

public protocol CardView: View {
    
    associatedtype Model: Card
    
    var card: Model { get }
    var aspectRatio: CGSize { get }
}
