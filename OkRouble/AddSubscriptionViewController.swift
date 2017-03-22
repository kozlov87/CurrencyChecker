//
//  AddSubscriptionViewController.swift
//  ExchangeRates
//
//  Created by Козлов Егор on 21.03.17.
//  Copyright © 2017 Козлов Егор. All rights reserved.
//

import UIKit
import DownPicker

class AddSubscriptionViewController: UIViewController {
    
    var dp: DownPicker? {
        didSet {
            dp!.addTarget(self, action: #selector(AddSubscriptionViewController.dp_Selected(_:)), for: .valueChanged)
        }
    }
    
    @IBOutlet weak var lessOrGreaterControl: UISegmentedControl!
    @IBOutlet weak var downPickerTextField: UITextField!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var stepper: UIStepper!
    
    let currencyMultiplier: Double = 5
    
    var value: Double = 0 {
        didSet {
            valueTextField.text = "\(value)"
        }
    }
    
    let currencies = Currency.all(CoreDataHelper.instance.context)!
    
    @IBAction func stepperChanged(_ sender: UIStepper) {
        value = sender.value / currencyMultiplier
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let data = currencies.map(){$0.name!}
        dp = DownPicker(textField: downPickerTextField, withData: data)
        downPickerTextField.placeholder = "Выбрать валюту"
        downPickerTextField.becomeFirstResponder()
    }
    
    func dp_Selected(_ picker: DownPicker) {
        let selectedCurrency = currencies[picker.selectedIndex]
        value = selectedCurrency.rate!.doubleValue
        stepper.value = value * currencyMultiplier
    }
    

    @IBAction func done(_ sender: AnyObject) {
        let selectedCurrency = currencies[dp!.selectedIndex]
        
        let subscription: Subscription = Subscription()
        subscription.currency = selectedCurrency
        subscription.value = NSDecimalNumber(value: value as Double)
        subscription.created = Date().timeIntervalSince1970
        subscription.type = lessOrGreaterControl.selectedSegmentIndex
        subscription.enabled = true
        CoreDataHelper.instance.save()
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
