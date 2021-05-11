//
//  ImagesFRC.swift
//  BachelorProject
//
//  Created by Павел Снижко on 11.05.2021.
//

import Foundation

import CoreData

class ImagesFRC: NSFetchedResultsController<ImageEntity> {
    
    class func make(at context: NSManagedObjectContext) -> ImagesFRC {
        
        let request: NSFetchRequest<ImageEntity> = ImageEntity.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(ImageEntity.name),
                                    ascending: true)
        request.sortDescriptors = [sort]
        let result = ImagesFRC(fetchRequest: request,
                                 managedObjectContext: context,
                                 sectionNameKeyPath: nil,
                                 cacheName: nil)
        return result
    }
}
