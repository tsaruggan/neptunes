//
//  UIColor+hex.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-14.
//

import UIKit
import Foundation

extension UIColor {
    
    var hex: String {
        guard let components = cgColor.components else {
            return "#000000" // Fallback for colors that don't have components
        }
        
        let r = components.indices.contains(0) ? components[0] : 0.0
        let g = components.indices.contains(1) ? components[1] : 0.0
        let b = components.indices.contains(2) ? components[2] : 0.0
        
        let hexString = String(format: "#%02lX%02lX%02lX",
                               lroundf(Float(r * 255)),
                               lroundf(Float(g * 255)),
                               lroundf(Float(b * 255)))
        return hexString
    }
    
    convenience init(hex: String) {
        var colorString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        colorString = colorString.replacingOccurrences(of: "#", with: "").uppercased()
        
        let alpha: CGFloat = 1.0
        let red: CGFloat = UIColor.colorComponentFrom(colorString: colorString, start: 0, length: 2)
        let green: CGFloat = UIColor.colorComponentFrom(colorString: colorString, start: 2, length: 2)
        let blue: CGFloat = UIColor.colorComponentFrom(colorString: colorString, start: 4, length: 2)
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    static private func colorComponentFrom(colorString: String, start: Int, length: Int) -> CGFloat {
        
        let startIndex = colorString.index(colorString.startIndex, offsetBy: start)
        let endIndex = colorString.index(startIndex, offsetBy: length)
        let subString = colorString[startIndex..<endIndex]
        let fullHexString = length == 2 ? subString : "\(subString)\(subString)"
        var hexComponent: UInt32 = 0
        
        guard Scanner(string: String(fullHexString)).scanHexInt32(&hexComponent) else {
            return 0
        }
        let hexFloat: CGFloat = CGFloat(hexComponent)
        let floatValue: CGFloat = CGFloat(hexFloat / 255.0)
        return floatValue
    }
    
}
