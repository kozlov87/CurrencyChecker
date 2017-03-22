//
//  TabBarController+textColor.swift
//  ExchangeRates
//
//  Created by Козлов Егор on 16.03.17.
//  Copyright © 2017 Козлов Егор. All rights reserved.
//

import UIKit

extension UIColor {
    static func UIColorFromRGB(_ rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    static func cloverColor() -> UIColor {
        return UIColor.UIColorFromRGB(0x339900)
    }
}

extension UITabBarController {
    
    override open func viewWillAppear(_ animated: Bool) {
        for item in self.tabBar.items! {
            let selectedItem = [NSForegroundColorAttributeName: UIColor.cloverColor()]
            item.setTitleTextAttributes(selectedItem, for: .selected)
        }
    }
}
