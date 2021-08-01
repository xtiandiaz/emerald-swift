//
//  Anchor.swift
//  Emerald
//
//  Created by Cristian Díaz on 31.7.2021.
//

import CoreGraphics

public enum Anchor {
    
    case center
    case top, topRight, topLeft
    case right
    case bottom, bottomRight, bottomLeft
    case left
    
    public func coordinates(in rect: CGRect) -> CGPoint {
        switch self {
        case .center: return rect.center
        case .top: return CGPoint(x: rect.center.x, y: rect.maxY)
        case .topLeft: return CGPoint(x: rect.minX, y: rect.maxY)
        case .topRight: return CGPoint(x: rect.maxX, y: rect.maxY)
        case .right: return CGPoint(x: rect.minX, y: rect.center.y)
        case .bottom: return CGPoint(x: rect.center.x, y: rect.minY)
        case .bottomLeft: return CGPoint(x: rect.minX, y: rect.minY)
        case .bottomRight: return CGPoint(x: rect.maxX, y: rect.minY)
        case .left: return CGPoint(x: rect.maxX, y: rect.center.y)
        }
    }
}
