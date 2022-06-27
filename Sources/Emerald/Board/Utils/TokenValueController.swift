//
//  TokenValue.swift
//  Emerald
//
//  Created by Cristian Diaz on 27.6.2022.
//

import Foundation
import SwiftUI

public enum TokenValue {
    
    case single(Int),
         dual(front: Int, back: Int)
}

public class TokenValueController {
    
    public let originalValue: TokenValue
    
    public init(value: TokenValue) {
        originalValue = value
        
        switch value {
        case .single(let value):
            values[.front] = value.sanitized()
        case .dual(let front, let back):
            values[.front] = front.sanitized()
            values[.back] = back.sanitized()
        }
    }
    
    public func valueFor(side: FlipSide) -> Int {
        values[actualSide(for: side)]!
    }
    
    public func setValue(_ value: Int, forSide side: FlipSide) {
        values[actualSide(for: side)] = value.sanitized()
    }
    
    // MARK: - Private
    
    private var values = [FlipSide: Int]()
    
    private func actualSide(for side: FlipSide) -> FlipSide {
        switch originalValue {
        case .single: return .front
        case .dual: return side
        }
    }
}

extension TokenValueController {
    
    public func stringValueFor(side: FlipSide) -> String {
        "\(valueFor(side: side))"
    }
    
    public func attributedValueFor(
        side: FlipSide,
        withSize size: CGFloat,
        color: UIColor
    ) -> NSAttributedString {
        TextUtils.attributedText(
            stringValueFor(side: side),
            size: size,
            weight: .heavy,
            color: color
        )
    }
}

private extension Int {
    
    func sanitized() -> Int {
        Swift.max(self, 0)
    }
}
