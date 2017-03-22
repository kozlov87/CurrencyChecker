//
//  Subscription.swift
//  OkRouble
//
//  Created by Козлов Егор on 22.03.17.
//  Copyright © 2017 Козлов Егор. All rights reserved.
//

import Foundation
import CoreData


class Subscription: NSManagedObject {
    fileprivate static let subType = [">", "<"]
    fileprivate static let subTypeOp: [(Double, Double) -> Bool] = [{ $0 > $1 }, { $0 < $1 }]
    
    var operationClosure : (Double, Double) -> Bool {
        get {
            let index = self.type
            return Subscription.subTypeOp[index]
        }
    }
    
    var operationCharacter: String {
        get {
            let index = self.type
            return Subscription.subType[index]
        }
    }
    
    class var _entity: NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: "Subscription", in: CoreDataHelper.instance.context)!
    }
    
    convenience init() {
        self.init(entity: Subscription.entity(), insertInto: CoreDataHelper.instance.context)
    }
    
    class func get(_ context: NSManagedObjectContext) -> [Subscription]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = _entity
        do {
            return try context.fetch(fetchRequest) as? [Subscription]
        } catch {
            print(error)
            abort()
        }
        return nil
    }
}
