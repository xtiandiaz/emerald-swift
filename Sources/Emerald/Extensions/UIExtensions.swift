//
//  UIExtensions.swift
//  Emerald
//
//  Created by Cristian Díaz on 31.7.2021.
//

import UIKit

public extension UIColor {
    
    static func * (lhs: UIColor, rhs: UIColor) -> UIColor {
        typealias Components = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
        
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
