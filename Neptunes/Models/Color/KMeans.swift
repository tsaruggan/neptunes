//
//  KMeans.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-10.
//

import Foundation
import UIKit
import SwiftImage

class KMeans<Label: Hashable> {
    let numCenters: Int
    let labels: [Label]
    private(set) var centroids = [Vector]()
    
    init(labels: [Label]) {
        assert(labels.count > 1, "Exception: KMeans with less than 2 centers.")
        self.labels = labels
        self.numCenters = labels.count
    }
    
    private func indexOfNearestCenter(_ x: Vector, centers: [Vector]) -> Int {
        var nearestDist = Double.greatestFiniteMagnitude
        var minIndex = 0
        
        for (idx, center) in centers.enumerated() {
            let dist = x.distanceTo(center)
            if dist < nearestDist {
                minIndex = idx
                nearestDist = dist
            }
        }
        return minIndex
    }
    
    func trainCenters(_ points: [Vector], convergeDistance: Double) {
        let zeroVector = Vector([Double](repeating: 0, count: points[0].length))
        
        // Randomly take k objects from the input data to make the initial centroids.
        var centers = reservoirSample(points, k: numCenters)
        
        var centerMoveDist = 0.0
        repeat {
            // This array keeps track of which data points belong to which centroids.
            var classification: [[Vector]] = .init(repeating: [], count: numCenters)
            
            // For each data point, find the centroid that it is closest to.
            for p in points {
                let classIndex = indexOfNearestCenter(p, centers: centers)
                classification[classIndex].append(p)
            }
            
            // Take the average of all the data points that belong to each centroid.
            // This moves the centroid to a new position.
            let newCenters = classification.map { assignedPoints in
                assignedPoints.reduce(zeroVector, +) / Double(assignedPoints.count)
            }
            
            // Find out how far each centroid moved since the last iteration. If it's
            // only a small distance, then we're done.
            centerMoveDist = 0.0
            for idx in 0..<numCenters {
                centerMoveDist += centers[idx].distanceTo(newCenters[idx])
            }
            
            centers = newCenters
        } while centerMoveDist > convergeDistance
        
        centroids = centers
    }
    
    func fit(_ point: Vector) -> Label {
        assert(!centroids.isEmpty, "Exception: KMeans tried to fit on a non trained model.")
        
        let centroidIndex = indexOfNearestCenter(point, centers: centroids)
        return labels[centroidIndex]
    }
    
    func fit(_ points: [Vector]) -> [Label] {
        assert(!centroids.isEmpty, "Exception: KMeans tried to fit on a non trained model.")
        
        return points.map(fit)
    }
}

// Pick k random elements from samples
func reservoirSample<T>(_ samples: [T], k: Int) -> [T] {
    var result = [T]()
    
    // Fill the result array with first k elements
    for i in 0..<k {
        result.append(samples[i])
    }
    
    // Randomly replace elements from remaining pool
    for i in k..<samples.count {
        let j = Int(arc4random_uniform(UInt32(i + 1)))
        if j < k {
            result[j] = samples[i]
        }
    }
    return result
}

struct Vector: CustomStringConvertible, Equatable {
    private(set) var length = 0
    private(set) var data: [Double]
    
    init(_ data: [Double]) {
        self.data = data
        self.length = data.count
    }
    
    var description: String {
        return "Vector (\(data)"
    }
    
    func distanceTo(_ other: Vector) -> Double {
        var result = 0.0
        for idx in 0..<length {
            result += pow(data[idx] - other.data[idx], 2.0)
        }
        return sqrt(result)
    }
}

func == (left: Vector, right: Vector) -> Bool {
    for idx in 0..<left.length {
        if left.data[idx] != right.data[idx] {
            return false
        }
    }
    return true
}

func + (left: Vector, right: Vector) -> Vector {
    var results = [Double]()
    for idx in 0..<left.length {
        results.append(left.data[idx] + right.data[idx])
    }
    return Vector(results)
}

func += (left: inout Vector, right: Vector) {
    left = left + right
}

func - (left: Vector, right: Vector) -> Vector {
    var results = [Double]()
    for idx in 0..<left.length {
        results.append(left.data[idx] - right.data[idx])
    }
    return Vector(results)
}

func -= (left: inout Vector, right: Vector) {
    left = left - right
}

func / (left: Vector, right: Double) -> Vector {
    var results = [Double](repeating: 0, count: left.length)
    for (idx, value) in left.data.enumerated() {
        results[idx] = value / right
    }
    return Vector(results)
}

func /= (left: inout Vector, right: Double) {
    left = left / right
}

extension RGBA where Channel == UInt8 {
    var redDouble: Double { return Double(red) }
    var greenDouble: Double { return Double(green) }
    var blueDouble: Double { return Double(blue) }
    var alphaDouble: Double { return Double(alpha) }
}

func getColorsFromAlbumArt(uiImage: UIImage) -> [UIColor] {
    let image = Image<RGBA<UInt8>>(cgImage: uiImage.cgImage!)
    let newSize = 16
    let resizedImage = image.resizedTo(width: newSize, height: newSize, interpolatedBy: .nearestNeighbor)
    let pixels: [Vector] = resizedImage.map { pixel in
        Vector([pixel.redDouble, pixel.greenDouble, pixel.blueDouble])
    }
    let kmm = KMeans<Character>(labels: ["A", "B", "C", "D", "E"])
    kmm.trainCenters(pixels, convergeDistance: 0.01)
    let centroids = kmm.centroids.sorted { c1, c2 in
        return colorfulness(c1.data[0], c1.data[1], c1.data[2])
        > colorfulness(c2.data[0], c2.data[1], c2.data[2])
    }
    let colors = centroids.map { centroid in
            return UIColor(red: centroid.data[0] / 255.0,
                           green: centroid.data[1] / 255.0,
                           blue: centroid.data[2] / 255.0,
                           alpha: 1)
    }
    return colors
}

func colorfulness(_ r: Double, _ g: Double, _ b: Double) -> Double {
    let rg = abs(r - g)
    let yb = abs(0.5 * (r + g) - b)
    let root = (pow(rg, 2) + pow(yb, 2)).squareRoot()
    return root * 0.3
}

public extension UIColor {
    /// The RGBA components associated with a `UIColor` instance.
    var components: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        let components = self.cgColor.components!
        
        switch components.count == 2 {
        case true : return (r: components[0], g: components[0], b: components[0], a: components[1])
        case false: return (r: components[0], g: components[1], b: components[2], a: components[3])
        }
    }
    
    /**
     Returns a `UIColor` by interpolating between two other `UIColor`s.
     - Parameter fromColor: The `UIColor` to interpolate from
     - Parameter toColor:   The `UIColor` to interpolate to (e.g. when fully interpolated)
     - Parameter progress:  The interpolation progess; must be a `CGFloat` from 0 to 1
     - Returns: The interpolated `UIColor` for the given progress point
     */
    static func interpolate(from fromColor: UIColor, to toColor: UIColor, with progress: CGFloat) -> UIColor {
        let fromComponents = fromColor.components
        let toComponents = toColor.components
        
        let r = (1 - progress) * fromComponents.r + progress * toComponents.r
        let g = (1 - progress) * fromComponents.g + progress * toComponents.g
        let b = (1 - progress) * fromComponents.b + progress * toComponents.b
        let a = (1 - progress) * fromComponents.a + progress * toComponents.a
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}


//let image = UIImage(named: "drake.jpeg")
//let colors = getColorsFromAlbumArt(uiImage: image!)
//let foreground = UIColor.interpolate(from: color, to: .white, with: 0.5)
//let background = UIColor.interpolate(from: color, to: .black, with: 0.5)

