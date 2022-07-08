//
//  Token.swift
//  Emerald
//
//  Created by Cristian Diaz on 6.7.2022.
//

import Foundation
import SwiftUI

public protocol Token: Identifiable, ObservableObject {
    
    func canInteract(with other: Self) -> Bool
    func interact(with other: Self)
}
