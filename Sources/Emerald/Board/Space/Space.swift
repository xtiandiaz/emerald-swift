//
//  Space.swift
//  Emerald
//
//  Created by Cristian Diaz on 6.7.2022.
//

import Foundation
import SwiftUI

public protocol Space: ObservableObject {
    
    associatedtype TokenModel: Token
    
    var tokenCapacity: Int { get }
    var tokenCount: Int { get }
    
    var isEmpty: Bool { get }
    var isHighlighted: Bool { get set }
    
    func peek(at localPosition: CGPoint) -> TokenModel?
    func take(at localPosition: CGPoint) -> TokenModel?
    
    func canInteract(with token: TokenModel) -> Bool
    func interact(with token: TokenModel)
    
    func canPlace(token: TokenModel) -> Bool
    func place(token: TokenModel)
}
