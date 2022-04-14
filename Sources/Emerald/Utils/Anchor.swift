//
//  Anchor.swift
//  Emerald
//
//  Created by Cristian Díaz on 31.7.2021.
//

import CoreGraphics

public enum Anchor {
    
    case center
    case top, topLeft, topRight
    case left
    case bottom, bottomLeft, bottomRight
    case right
    
    public var point: CGPoint {
        switch self {
        case .center: return CGPoint(xy: 0.5)
        case .top: return CGPoint(x: 0.5, y: 1)
        case .topLeft: return CGPoint(y: 1)
        case .topRight: return .one
        case .left: return CGPoint(y: 0.5)
        case .bottom: return CGPoint(x: 0.5)
        case .bottomLeft: return .zero
        case .bottomRight: return CGPoint(x: 1)
        case .right: return CGPoint(x: 1, y: 0.5)
        }
    }
    
    public var uiPoint: CGPoint {
        switch self {
        case .bottom: return Anchor.top.point
        case .bottomLeft: return Anchor.topLeft.point
        case .bottomRight: return Anchor.topRight.point
        case .top: return Anchor.bottom.point
        case .topLeft: return Anchor.bottomLeft.point
        case .topRight: return Anchor.bottomRight.point
        default: return point
        }
    }
    
    public func point(in rect: CGRect) -> CGPoint {
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
