//
//  Space.swift
//  Emerald
//
//  Created by Cristian Diaz on 6.7.2022.
//

import Foundation
import SwiftUI

public protocol Space {
    
    associatedtype TokenModel: Token
    
    func peek(at localPosition: CGPoint) -> TokenModel?
    func take(at localPosition: CGPoint) -> TokenModel?
    
    func canInteract(with token: TokenModel) -> Bool
    func interact(with token: TokenModel)
    
    func canPlace(token: TokenModel) -> Bool
    func place(token: TokenModel)
}

public protocol SpaceView: View {
    
    associatedtype Model: Space
    
    var space: Model { get }
}
