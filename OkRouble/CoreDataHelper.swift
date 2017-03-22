//
//  CoreDataHelper.swift
//  CoreDataHelper
//
//  Created by Козлов Егор on 10.03.17.
//  Copyright © 2017 Козлов Егор. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHelper: NSObject {
    
    // singleton
    class var instance: CoreDataHelper {
        struct Singleton {
            static let instance = CoreDataHelper()
        }
        return Singleton.instance
    }
    
    let coordinator: NSPersistentStoreCoordinator
    let model: NSManagedObjectModel
    let context: NSManagedObjectContext
    
    fileprivate override init() {
        let modelUrl = Bundle.main.url(forResource: "exchangeModel", withExtension: "mom")!
        model = NSManagedObjectModel(contentsOf: modelUrl)!
        
        let fileManager = FileManager.default
        let docsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).last! as URL
        let storeURL = docsURL.appendingPathComponent("exchangeModel.sqlite")
        
        print("Model is located in \(storeURL)")
        
        coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        } catch {
            let failureReason = "There was an error creating or loading the application's saved data."
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
            dict[NSUnderlyingErrorKey] = error as NSError
            
            let wrappedError = NSError(domain: "error_domain", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            
            // delete after development
            abort()
        }
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        
        super.init()
    }
    
    func save() {
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
}
