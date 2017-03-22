//
//  Subscription+CoreDataProperties.swift
//  OkRouble
//
//  Created by Козлов Егор on 22.03.17.
//  Copyright © 2017 Козлов Егор. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Subscription {

    @NSManaged var created: TimeInterval
    @NSManaged var enabled: Bool
    @NSManaged var type: Int
    @NSManaged var value: NSDecimalNumber?
    @NSManaged var currency: Currency?

}
