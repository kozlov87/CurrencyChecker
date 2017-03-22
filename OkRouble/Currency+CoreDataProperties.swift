//
//  Currency+CoreDataProperties.swift
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

extension Currency {

    @NSManaged var code: String?
    @NSManaged var imageName: String?
    @NSManaged var maxRate: NSDecimalNumber?
    @NSManaged var minRate: NSDecimalNumber?
    @NSManaged var name: String?
    @NSManaged var previousDate: String?
    @NSManaged var previousRate: NSDecimalNumber?
    @NSManaged var rate: NSDecimalNumber?
    @NSManaged var updateDate: String?
    @NSManaged var subscriptions: NSSet?

}
