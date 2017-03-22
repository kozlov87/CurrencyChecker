//
//  CurrencyFormatter.swift
//  OkRouble
//
//  Created by Козлов Егор on 23.03.17.
//  Copyright © 2017 Козлов Егор. All rights reserved.
//

import Foundation


class CurrencyFormatter: NumberFormatter {
    override init() {
        super.init()
        self.numberStyle = .decimal
        self.maximumFractionDigits = 2
        self.minimumFractionDigits = 2
        self.usesSignificantDigits = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.numberStyle = .decimal
        self.maximumFractionDigits = 2
        self.minimumFractionDigits = 2
        self.usesSignificantDigits = false
    }
}
