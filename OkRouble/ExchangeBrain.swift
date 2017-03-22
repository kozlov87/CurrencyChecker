//
//  ExchangeBrain.swift
//  OkRouble
//
//  Created by Козлов Егор on 23.03.17.
//  Copyright © 2017 Козлов Егор. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

class ExchangeBrain {
    
    enum ExecutionResult {
        case done
        case noData
        case fail
    }
    
    fileprivate struct Constants {
        static let resourceName = "initialValues"
        static let dateFormat = "M/dd/yyyy/hh:mma"
    }
    
    fileprivate static var url: URL? = {
    
        if let pathToPlist = Bundle.main.path(forResource: Constants.resourceName, ofType: "plist") {
            if let data = NSDictionary(contentsOfFile: pathToPlist){
                var codes = [String]()
                
                for currency in (data["currencies"] as! NSArray){
                    if let item = currency as? Dictionary<String, String> {
                        codes.append(item["code"]!)
                    }
                }
                let dataProvider = data["dataProvider"] as! Dictionary<String, String>
                
                let domain = dataProvider["domain"]!
                let tableName = dataProvider["table"]!
                let query = "select * from \(tableName) where pair='\(codes.joined(separator: ","))'".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                let responseFormat = dataProvider["format"]!
                let env = dataProvider["env"]!
                
                let urlString = "\(domain)?q=\(query)&format=\(responseFormat)&env=\(env)"
                return URL(string: urlString)
            }
        }
        return nil
    }()
    
    fileprivate static func initDB() {
        let context = CoreDataHelper.instance.context
        
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = Currency.entity()
        
        var existing = [Currency]()
        
        do {
            existing = try context.fetch(request) as! [Currency]
        } catch {
            print(error)
        }

        if let pathToPlist = Bundle.main.path(forResource: Constants.resourceName, ofType: "plist") {
            if let data = NSDictionary(contentsOfFile: pathToPlist){
                for currency in (data["currencies"] as! NSArray){
                    let current = currency as! Dictionary<String, String>
                    
                    let code = current["code"]
                    
                    var isNew = true
                    for obj in existing {
                        if obj.code == code {
                            isNew = false
                        }
                    }
                    guard isNew else {
                        continue
                    }
                    
                    let newCurrency = Currency()
                    newCurrency.code = code
                    newCurrency.name = current["name"]
                    newCurrency.imageName = current["image"]
                    CoreDataHelper.instance.save()
                }
            }
        }
    }
    fileprivate static func notify(_ subscription: Subscription) {
        let notification = UILocalNotification()
        let value = CurrencyFormatter().string(from: subscription.value!)
        notification.alertBody = "Поздравляем, \(subscription.currency!.name!) \(subscription.operationCharacter) \(value)"
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    fileprivate static func checkSubscriptions(_ context: NSManagedObjectContext) {
        if let subscriptions = Subscription.get(context) {
            for subscription in subscriptions {
                guard subscription.enabled else {
                    continue
                }
                let compareFunc = subscription.operationClosure
                if compareFunc(subscription.currency!.rate! as Double, subscription.value! as Double) {
                    notify(subscription)
                    CoreDataHelper.instance.context.delete(subscription)
                }
            }
        }
    }
    
    static func updateData(completionHandler: ((ExecutionResult) -> Void)! = nil) {
        
        func success() {
            checkSubscriptions(CoreDataHelper.instance.context)
            if completionHandler != nil {
                completionHandler(ExecutionResult.done)
            }
        }
        
        func noData() {
            checkSubscriptions(CoreDataHelper.instance.context)
            if completionHandler != nil {
                completionHandler(ExecutionResult.noData)
            }
        }
        
        func fail() {
            if completionHandler != nil {
                completionHandler(ExecutionResult.fail)
            }
        }
        
        let context = CoreDataHelper.instance.context
        
        ExchangeBrain.initDB()
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        if let url = url {
            let task = session.dataTask(with: url, completionHandler: {(data, response, error) in
                if let error = error {
                    print("error -> \(error.localizedDescription)")
                } else {
                    if let rates = JSON(data: data!)["query"]["results"]["rate"].array {
                        var successfullyUpdated = 0
                        for rateDict in rates {
                            if let id = rateDict["id"].string {
                                let unwrappedRate = rateDict["Rate"].doubleValue
                                let date = rateDict["Date"].string
                                let time = rateDict["Time"].string
                                
                                guard let unwrapedDate = date, let unwrapedTime = time else {
                                    continue
                                }
                                
                                let fullDate = unwrapedDate + "/" + unwrapedTime
                                
                                let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
                                fetchRequest.predicate = NSPredicate(format: "code == %@", id)
                                fetchRequest.entity = Currency.entity()
                                do {
                                    let data = try context.fetch(fetchRequest) as! [Currency]
                                    if let value = data.first {
                                        guard value.updateDate != fullDate else {
                                            continue
                                        }
                                        successfullyUpdated += 1
                                        value.previousRate = value.rate
                                        value.rate = NSDecimalNumber(value: unwrappedRate as Double)
                                        value.previousDate = value.updateDate
                                        value.updateDate = fullDate
                                        if value.minRate == nil || (value.minRate != nil && value.minRate!.doubleValue > unwrappedRate) {
                                            value.minRate = value.rate
                                        }
                                        if value.maxRate == nil || (value.maxRate != nil && value.maxRate!.doubleValue < unwrappedRate) {
                                            value.maxRate = value.rate
                                        }
                                    }
                                } catch {
                                    print(error)
                                }
                            }
                        }
                        if successfullyUpdated > 0 {
                            CoreDataHelper.instance.save()
                            success()
                            return
                        } else {
                            noData()
                            return
                        }
                    }
                }
                fail()
            }) 
            task.resume()
        }
    }

}
