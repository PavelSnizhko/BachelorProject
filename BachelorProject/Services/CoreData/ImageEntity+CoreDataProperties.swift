//
//  ImageEntity+CoreDataProperties.swift
//  
//
//  Created by Павел Снижко on 11.05.2021.
//
//

import Foundation
import CoreData


extension ImageEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageEntity> {
        return NSFetchRequest<ImageEntity>(entityName: "ImageEntity")
    }

    @NSManaged public var image: Data?
    @NSManaged public var data: Date?

}
