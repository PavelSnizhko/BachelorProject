//
//  ImageEntity+CoreDataProperties.swift
//  BachelorProject
//
//  Created by pavlo.snizhko on 11.09.2022.
//
//

import Foundation
import CoreData


extension ImageEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageEntity> {
        return NSFetchRequest<ImageEntity>(entityName: "ImageEntity")
    }

    @NSManaged public var date: Date?
    @NSManaged public var image: Data?

}

extension ImageEntity : Identifiable {

}
