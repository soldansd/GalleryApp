//
//  Extension+UIFont.swift
//  Gallery
//
//  Created by Даниил Соловьев on 11/03/2025.
//

import UIKit

extension UIFont {
    
    static func prostoOneRegular(size: CGFloat) -> UIFont {
        let font = UIFont(name: "ProstoOne-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
        return UIFontMetrics.default.scaledFont(for: font)
    }
    
    static func openSans(size: CGFloat) -> UIFont {
        let font = UIFont(name: "OpenSansRoman-SemiBold", size: size) ?? UIFont.systemFont(ofSize: size)
        return UIFontMetrics.default.scaledFont(for: font)
    }
}
