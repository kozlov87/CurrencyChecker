//
//  AppDelegate.swift
//  OkRouble
//
//  Created by Козлов Егор on 22.03.17.
//  Copyright © 2017 Козлов Егор. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().barTintColor = UIColor.cloverColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UINavigationBar.appearance().tintColor = UIColor.white
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: UIUserNotificationType.alert, categories: nil))
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: UIUserNotificationType.badge, categories: nil))
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: UIUserNotificationType.sound, categories: nil))
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        ExchangeBrain.updateData { (success) -> Void in
            switch success {
            case .done:
                completionHandler(.newData)
            case .fail:
                completionHandler(.failed)
            case .noData:
                completionHandler(.noData)
            }
        }
    }

}

