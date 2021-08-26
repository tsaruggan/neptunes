//
//  Album+CoreDataClass.swift
//  Album
//
//  Created by Saruggan Thiruchelvan on 2021-08-25.
//
//

import Foundation
import CoreData

@objc(Album)
public class Album: NSManagedObject {
    var palette = Palette()
}
