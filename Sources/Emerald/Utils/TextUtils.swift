//
//  TextUtils.swift
//  Emerald
//
//  Created by Cristian Diaz on 19.4.2022.
//

import Foundation
import SpriteKit

public struct TextUtils {

    public static func attributedText(
        _ text: String,
        size: CGFloat,
        weight: UIFont.Weight,
        color: UIColor,
        paragraphStyle: NSParagraphStyle? = nil
    ) -> NSAttributedString {
        attributedText(
            text,
            font: UIFont.systemFont(ofSize: size, weight: weight),
            color: color,
            paragraphStyle: paragraphStyle
        )
    }
    
    public static func attributedText(
        _ text: String,
        font: UIFont,
        color: UIColor,
        paragraphStyle: NSParagraphStyle? = nil
    ) -> NSAttributedString {
        var attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
        ]
        
        if let paragraphStyle = paragraphStyle {
            attributes[.paragraphStyle] = paragraphStyle
        }
        
        return NSAttributedString(string: text, attributes: attributes)
    }
}
