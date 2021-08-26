//
//  Artist+CoreDataClass.swift
//  Artist
//
//  Created by Saruggan Thiruchelvan on 2021-08-25.
//
//

import Foundation
import CoreData

@objc(Artist)
public class Artist: NSManagedObject {

}

extension Artist : Findable {
    var date: Date? {
        nil
    }
    

}
