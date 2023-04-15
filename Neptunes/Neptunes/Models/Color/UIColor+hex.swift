//
//  UIColor+hex.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-14.
//

import UIKit
import Foundation

extension UIColor {
    
    // MARK: - Initialization
    
    //    convenience init?(hex: String) {
    //        var hexNormalized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    //        hexNormalized = hexNormalized.replacingOccurrences(of: "#", with: "")
    //
    //        // Helpers
    //        var rgb: UInt32 = 0
    //        var r: CGFloat = 0.0
    //        var g: CGFloat = 0.0
    //        var b: CGFloat = 0.0
    //        var a: CGFloat = 1.0
    //        let length = hexNormalized.count
    //
    //        // Create Scanner
    //        Scanner(string: hexNormalized).scanHexInt32(&rgb)
    //
    //        if length == 6 {
    //            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
    //            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
    //            b = CGFloat(rgb & 0x0000FF) / 255.0
    //
    //        } else if length == 8 {
    //            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
    //            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
    //            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
    //            a = CGFloat(rgb & 0x000000FF) / 255.0
    //
    //        } else {
    //            return nil
    //        }
    //
    //        self.init(red: r, green: g, blue: b, alpha: a)
    //    }
    
//    convenience init(hex: String) {
//        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
//
//        if hexFormatted.hasPrefix("#") {
//            hexFormatted = String(hexFormatted.dropFirst())
//        }
//
//        assert(hexFormatted.count == 6, "Invalid hex code used.")
//
//        var rgbValue: UInt64 = 0
//        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
//
//        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
//                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
//                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
//                  alpha: 1.0)
//    }
    
    var hex: String {
        let components = cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        
        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        print(hexString)
        return hexString
    }
    
    convenience init(hex: String) {
        var colorString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        colorString = colorString.replacingOccurrences(of: "#", with: "").uppercased()
        
        print(colorString)
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
        print(floatValue)
        return floatValue
    }
    
}
