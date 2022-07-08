//
//  ViewExtensions.swift
//  Emerald
//
//  Created by Cristian Diaz on 7.7.2022.
//

import Foundation
import SwiftUI

extension View {
    
    public func zIndex(_ value: Int) -> some View {
        zIndex(Double(value))
    }
}
