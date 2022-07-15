//
//  Anchor.swift
//  Emerald
//
//  Created by Cristian Díaz on 31.7.2021.
//

import CoreGraphics

public enum Anchor {
    
    case center,
         top, topLeft, topRight,
         left,
         bottom, bottomLeft, bottomRight,
         right
    
    public var viewportCoordinates: CGPoint {
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
    
    public var uiViewportCoordinates: CGPoint {
        switch self {
        case .bottom: return Anchor.top.viewportCoordinates
        case .bottomLeft: return Anchor.topLeft.viewportCoordinates
        case .bottomRight: return Anchor.topRight.viewportCoordinates
        case .top: return Anchor.bottom.viewportCoordinates
        case .topLeft: return Anchor.bottomLeft.viewportCoordinates
        case .topRight: return Anchor.bottomRight.viewportCoordinates
        default: return viewportCoordinates
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
    
    public func uiPoint(in rect: CGRect) -> CGPoint {
        switch self {
        case .center: return rect.center
        case .top: return CGPoint(x: rect.center.x, y: rect.minY)
        case .topLeft: return CGPoint(x: rect.minX, y: rect.minY)
        case .topRight: return CGPoint(x: rect.maxX, y: rect.minY)
        case .right: return CGPoint(x: rect.minX, y: rect.center.y)
        case .bottom: return CGPoint(x: rect.center.x, y: rect.maxY)
        case .bottomLeft: return CGPoint(x: rect.minX, y: rect.maxY)
        case .bottomRight: return CGPoint(x: rect.maxX, y: rect.maxY)
        case .left: return CGPoint(x: rect.maxX, y: rect.center.y)
        }
    }
}
