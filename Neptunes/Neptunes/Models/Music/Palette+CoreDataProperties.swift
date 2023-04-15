//
//  Palette+CoreDataProperties.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-14.
//
//

import Foundation
import CoreData
import SwiftUI

extension Palette {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Palette> {
        return NSFetchRequest<Palette>(entityName: "Palette")
    }
    
    @NSManaged public var accentDark: String
    @NSManaged public var accentLight: String
    @NSManaged public var backgroundDark: String
    @NSManaged public var backgroundLight: String
    @NSManaged public var primaryDark: String
    @NSManaged public var primaryLight: String
    @NSManaged public var secondaryDark: String
    @NSManaged public var secondaryLight: String
    
}

extension Palette : Identifiable {
    
}

extension Palette {
    func primary(_ scheme: ColorScheme) -> Color? {
        return getColor(lightHex: primaryLight, darkHex: primaryDark, scheme: scheme)
    }
    
    func secondary(_ scheme: ColorScheme) -> Color? {
        return getColor(lightHex: secondaryLight, darkHex: secondaryDark, scheme: scheme)
    }
    
    func accent(_ scheme: ColorScheme) -> Color? {
        return getColor(lightHex: accentLight, darkHex: accentDark, scheme: scheme)
    }
    
    func background(_ scheme: ColorScheme) -> Color? {
        return getColor(lightHex: accentLight, darkHex: accentDark, scheme: scheme)
    }
    
    private func getColor(lightHex: String, darkHex: String, scheme: ColorScheme) -> Color? {
        switch scheme {
        case .light:
//            guard let uiColor = UIColor(hex: lightHex) else { return nil }
            return Color(uiColor: UIColor(hex: lightHex))
        case .dark:
//            guard let uiColor = UIColor(hex: darkHex) else { return nil }
            return Color(uiColor: UIColor(hex: darkHex))
        @unknown default:
//            guard let uiColor = UIColor(hex: lightHex) else { return nil }
            return Color(uiColor: UIColor(hex: lightHex))
        }
    }
}
