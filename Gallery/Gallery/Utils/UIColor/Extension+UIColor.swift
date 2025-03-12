//
//  Extension+UIColor.swift
//  Gallery
//
//  Created by Даниил Соловьев on 12/03/2025.
//
// swiftlint:disable all

import UIKit

extension UIColor {
    
    public convenience init?(hex: String) {
        let r, g, b: CGFloat
        
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        let scanner = Scanner(string: hexSanitized)
        var hexNumber: UInt64 = 0
        
        guard scanner.scanHexInt64(&hexNumber) else { return nil }
        
        if hexSanitized.count == 6 {
            r = CGFloat((hexNumber & 0xFF0000) >> 16) / 255
            g = CGFloat((hexNumber & 0x00FF00) >> 8) / 255
            b = CGFloat(hexNumber & 0x0000FF) / 255
            
            self.init(red: r, green: g, blue: b, alpha: 1.0)
        } else if hexSanitized.count == 8 {
            r = CGFloat((hexNumber & 0xFF000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00FF0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000FF00) >> 8) / 255
            let a = CGFloat(hexNumber & 0x000000FF) / 255
            
            self.init(red: r, green: g, blue: b, alpha: a)
        } else {
            return nil
        }
    }
}

