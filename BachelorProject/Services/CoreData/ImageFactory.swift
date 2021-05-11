//
//  ImageFactory.swift
//  BachelorProject
//
//  Created by Павел Снижко on 11.05.2021.
//

import CoreData

struct ImageFactory {

    static private var stack = CoreDataStack.shared
    
    static private var container = stack.container

    static private var viewContext = container.viewContext
}

enum FactoryError: Error {
    
    case objectAllocation
    case contextSaving
    case contextSync
}

extension ImageFactory {
    
    public static func makeImage(from data: Data, name: String, sha: String, completion: ((Result<ImageEntity, FactoryError>) -> Void)?) {
        
        let context = container.newBackgroundContext()
        context.perform {
            
            guard let imageEntity = NSEntityDescription.insertNewObject(forEntityName: "ImageEntity",
                                                                  into: context) as? ImageEntity else {
                viewContext.perform {
                    completion?(.failure(.objectAllocation))
                }
                return
            }
            
            imageEntity.image = data
            imageEntity.name = name
            imageEntity.sha = sha
            
            do {
                try context.save()
            } catch {
                viewContext.perform {
                    completion?(.failure(.contextSaving))
                }
                return
            }

            viewContext.perform {
                guard let result = try? viewContext.existingObject(with: imageEntity.objectID) as? ImageEntity else {
                    completion?(.failure(.contextSync))
                    return
                }

                completion?(.success(result))
            }
        }
    }
}
    
extension NSManagedObjectContext {
    func saveIfNeeded() throws {
        try save()
    }
}
