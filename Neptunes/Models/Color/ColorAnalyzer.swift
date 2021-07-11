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
    
    private static func getPixelsFromImage(cgImage: CGImage, _ resizedWidth: Int, _ resizedHeight: Int) -> [Vector] {
        let image = SwiftImage.Image<RGBA<UInt8>>(cgImage: cgImage)
        let resizedImage = image.resizedTo(width: resizedWidth, height: resizedHeight, interpolatedBy: .nearestNeighbor)
        let pixels: [Vector] = resizedImage.map { pixel in
            Vector([pixel.redDouble, pixel.greenDouble, pixel.blueDouble])
        }
        return pixels
    }
    
    private static func colorfulness(_ r: Double, _ g: Double, _ b: Double) -> Double {
        let rg = abs(r - g)
        let yb = abs(0.5 * (r + g) - b)
        let root = (pow(rg, 2) + pow(yb, 2)).squareRoot()
        return root * 0.3
    }
    
    static func getColors(albumArt: String, headerArt: String, _ numColors: Int) -> [Color] {
        let albumImage: CGImage = UIImage(named: albumArt)!.cgImage!
        let headerImage: CGImage = UIImage(named: headerArt)!.cgImage!
        let pixels = getPixelsFromImage(cgImage: albumImage, 16, 16) + getPixelsFromImage(cgImage: headerImage, 48, 16)
        let kmm = KMeans<Int>(labels: Array(1...numColors))
        kmm.trainCenters(pixels, convergeDistance: 0.01)
        let centroids = kmm.centroids.sorted { c1, c2 in
            return colorfulness(c1.data[0], c1.data[1], c1.data[2])
            > colorfulness(c2.data[0], c2.data[1], c2.data[2])
        }
        let colors = centroids.map { centroid in
                return Color(red: centroid.data[0] / 255.0,
                               green: centroid.data[1] / 255.0,
                               blue: centroid.data[2] / 255.0)
        }
        return colors
    }
}

extension RGBA where Channel == UInt8 {
    var redDouble: Double { return Double(red) }
    var greenDouble: Double { return Double(green) }
    var blueDouble: Double { return Double(blue) }
    var alphaDouble: Double { return Double(alpha) }
}
