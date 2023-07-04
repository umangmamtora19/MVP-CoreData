//
//  CoreDataManager.swift
//  BaseApp
//
//  Created by Umang on 16/12/22.
//

import Foundation
import CoreData

class CoreDataManager: NSObject {
    static let moduleName = "MVP+CoreData"
    
    static var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: moduleName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    static var applicationDocumentsDirectory: URL = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }()

//    MARK: - Create sqlite file in document directory
    static var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)

        let persistenStoreURL = applicationDocumentsDirectory.appendingPathComponent("\(moduleName).sqlite")
        appPrint("Database pathDatabase path : \(persistenStoreURL.absoluteURL)")
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistenStoreURL, options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption : true])
        } catch {
            fatalError("Persistent Store error: \(error)")
        }
        return coordinator
    }()

//    MARK: - Get ManagedObjectContext
    static var objectContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType) // As stated in the documentation change this depending on your need, but i recommend sticking to main thread if possible.

        context.persistentStoreCoordinator = persistentStoreCoordinator
        return context
    }()

//    MARK: - Save Changes
    static func saveToMainContext() { // Just a helper method for removing boilerplate code when you want to save. Remember this will be done on the main thread if called.
        if objectContext.hasChanges {
            do {
                appPrint("Data Saved")
                try objectContext.save()
            } catch {
                appPrint("Error saving main ManagedObjectContext: \(error.localizedDescription)")
            }
        }
    }
    

//    MARK: - Get Entity Description
    static func getEntityDescription(entityName: Entity) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: entityName.rawValue, in: objectContext)
    }
    
//    MARK: - Insert Operation
    static func insertData(in entity: NSEntityDescription) -> NSManagedObject {
        return NSManagedObject(entity: entity, insertInto: objectContext)
    }
}

 

protocol Fetchable {
    associatedtype FetchableType: NSManagedObject = Self

    static var entityName : String { get }
    static func objects(for predicate: NSPredicate?) throws -> [FetchableType]
}

extension Fetchable where Self : NSManagedObject, FetchableType == Self {
    static var entityName : String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }

    static func objects(for predicate: NSPredicate?) throws -> [FetchableType] {
        let request = NSFetchRequest<FetchableType>(entityName: entityName)
        request.predicate = predicate
        return try CoreDataManager.objectContext.fetch(request)
    }
}

enum DemoError: Error {
    case NoData
    case FetchError
}
