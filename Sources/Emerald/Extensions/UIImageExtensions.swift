//
//  UIImageExtensions.swift
//  Emerald
//
//  Created by Cristian Díaz on 5.9.2021.
//

import UIKit

public extension UIImage {
    
    static func gradient(_ gradient: Gradient, size: CGSize) -> UIImage! {
        UIGraphicsBeginImageContext(size)
        
        CAGradientLayer().configure {
            $0.colors = gradient.colors.map { $0.cgColor }
            $0.locations = gradient.locations.map { NSNumber(value: $0) }
            $0.startPoint = gradient.start.point
            $0.endPoint = gradient.end.point
            $0.frame = CGRect(origin: .zero, size: size)
        }.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }
}
