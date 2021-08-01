//
//  UIExtensions.swift
//  Emerald
//
//  Created by Cristian Díaz on 31.7.2021.
//

import UIKit

public extension UIColor {
    
    var accessibleFontColor: UIColor {
        var comps: Components = (red: 0, green: 0, blue: 0, alpha: 1)
        
        getRed(&comps.red, green: &comps.green, blue: &comps.blue, alpha: nil)
        
        return isLightColor(comps: comps) ? .black : .white
    }
    
    static func * (lhs: UIColor, rhs: UIColor) -> UIColor {
        var lhsComps: Components = (red: 0, green: 0, blue: 0, alpha: 0)
        var rhsComps: Components = (red: 0, green: 0, blue: 0, alpha: 0)
        
        lhs.getRed(&lhsComps.red, green: &lhsComps.green, blue: &lhsComps.blue, alpha: &lhsComps.alpha)
        rhs.getRed(&rhsComps.red, green: &rhsComps.green, blue: &rhsComps.blue, alpha: &rhsComps.alpha)
        
        return UIColor(
            red: lhsComps.red * rhsComps.red,
            green: lhsComps.green * rhsComps.green,
            blue: lhsComps.blue * rhsComps.blue,
            alpha: lhsComps.alpha * rhsComps.alpha)
    }
    
}

// MARK: - Internal

extension UIColor {
    
    typealias Components = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
}

// MARK: - Private

private extension UIColor {
    
    private func isLightColor(comps: Components) -> Bool {
        let lightRed = comps.red > 0.65
        let lightGreen = comps.green > 0.65
        let lightBlue = comps.blue > 0.65
        
        return [lightRed, lightGreen, lightBlue].reduce(0) { $1 ? $0 + 1 : $0 } >= 2
    }
}
