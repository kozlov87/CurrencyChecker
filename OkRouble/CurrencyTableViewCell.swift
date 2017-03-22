//
//  CurrencyTableViewCell.swift
//  ExchangeRates
//
//  Created by Козлов Егор on 15.03.17.
//  Copyright © 2017 Козлов Егор. All rights reserved.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var currencyTitle: UILabel!
    @IBOutlet weak var valueNow: UILabel!
    @IBOutlet weak var variation: UILabel!
    @IBOutlet weak var minValue: UILabel!
    @IBOutlet weak var maxValue: UILabel!
    
    func setData(_ item: Currency) {
        currencyTitle.text = item.name
        
        let formatter = CurrencyFormatter()
        
        valueNow.text = formatter.string(from: item.rate ?? 0)
        minValue.text = formatter.string(from: item.minRate ?? 0)
        maxValue.text = formatter.string(from: item.maxRate ?? 0)
        backgroundImage.image = UIImage(named: item.imageName!)
        

        if let nowRate = item.rate, let oldRate = item.previousRate {
            let newValue = nowRate.subtracting(oldRate)
            variation.text = formatter.string(from: newValue)
        }
    }
}
