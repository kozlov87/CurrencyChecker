//
//  Currency.swift
//  OkRouble
//
//  Created by Козлов Егор on 22.03.17.
//  Copyright © 2017 Козлов Егор. All rights reserved.
//

import Foundation
import CoreData

@objc(Currency)
class Currency: NSManagedObject {
    class var _entity: NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: "Currency", in: CoreDataHelper.instance.context)!
    }
    
    convenience init() {
        self.init(entity: Currency._entity, insertInto: CoreDataHelper.instance.context)
    }
    
    class func all(_ context: NSManagedObjectContext) -> [Currency]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = _entity
        do {
            return try context.fetch(fetchRequest) as? [Currency]
        } catch {
            print(error)
            abort()
        }
        return nil
    }
}
