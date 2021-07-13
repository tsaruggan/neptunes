//
//  ColorAnalyzer.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-11.
//

import Foundation
import UIKit
import SwiftImage
import SwiftUI

class ColorAnalyzer {
    
    static func getPixelsFromImage(cgImage: CGImage, _ resizedWidth: Int, _ resizedHeight: Int) -> [Vector] {
        let image = SwiftImage.Image<RGBA<UInt8>>(cgImage: cgImage)
        let resizedImage = image.resizedTo(width: resizedWidth, height: resizedHeight, interpolatedBy: .nearestNeighbor)
        let pixels: [Vector] = resizedImage.map { pixel in
            Vector([pixel.redDouble, pixel.greenDouble, pixel.blueDouble])
        }
        return pixels
    }
    
    static func getColors(albumArt: String, headerArt: String, _ numColors: Int) -> [UIColor] {
        let albumImage: CGImage = UIImage(named: albumArt)!.cgImage!
        let headerImage: CGImage = UIImage(named: headerArt)!.cgImage!
        
        let pixels = getPixelsFromImage(cgImage: albumImage, 16, 16) + getPixelsFromImage(cgImage: headerImage, 48, 16)
        let kmm = KMeans(numColors)
        kmm.trainCenters(pixels, convergeDistance: 0.01)

        let colors = kmm.centroids.map { centroid in
            return UIColor(red: centroid.data[0] / 255.0,
                           green: centroid.data[1] / 255.0,
                           blue: centroid.data[2] / 255.0,
                           alpha: 1.0
            )
        }
        let sortedColors = colors.sorted { $0.colorfulness > $1.colorfulness }
        return sortedColors
    }
    
}

extension RGBA where Channel == UInt8 {
    var redDouble: Double { return Double(red) }
    var greenDouble: Double { return Double(green) }
    var blueDouble: Double { return Double(blue) }
    var alphaDouble: Double { return Double(alpha) }
}

extension UIColor {
    var luminance: CGFloat {
        let ciColor = CIColor(color: self)
        func adjust(colorComponent: CGFloat) -> CGFloat {
            return (colorComponent < 0.04045) ? (colorComponent / 12.92) : pow((colorComponent + 0.055) / 1.055, 2.4)
        }
        return 0.2126 * adjust(colorComponent: ciColor.red) + 0.7152 * adjust(colorComponent: ciColor.green) + 0.0722 * adjust(colorComponent: ciColor.blue)
    }
    
    var colorfulness: CGFloat {
        var red: CGFloat        = 0.0
        var green: CGFloat      = 0.0
        var blue: CGFloat       = 0.0
        var alpha: CGFloat      = 0.0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let rg = abs(red - green)
        let yb = abs(0.5 * (red + green) - blue)
        let root = (pow(rg, 2) + pow(yb, 2)).squareRoot()
        return root * 0.3
    }
    
    func contrastRatio(with color: UIColor) -> CGFloat {
        let luminance1 = self.luminance
        let luminance2 = color.luminance
        let luminanceDarker = min(luminance1, luminance2)
        let luminanceLighter = max(luminance1, luminance2)
        return (luminanceLighter + 0.05) / (luminanceDarker + 0.05)
    }
    
    func adjustBrightness(_ newBrightness: CGFloat) -> UIColor {
        var hue: CGFloat        = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat      = 0.0
        
        self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        let newColor = UIColor( hue: hue, saturation: saturation, brightness: newBrightness, alpha: alpha)
        return newColor
    }
}
