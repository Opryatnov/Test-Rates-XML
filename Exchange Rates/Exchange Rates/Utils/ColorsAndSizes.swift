//
//  ColorsAndSizes.swift
//  Exchange Rates
//
//  Created by Dmitriy Opryatnov on 3/9/19.
//  Copyright © 2019 Dmitriy Opryatnov. All rights reserved.
//

import Foundation

import UIKit

extension UIColor {
    
    static func buttonColor() -> [String: UIColor] {
        let someDict:[String: UIColor] = ["customGray": UIColor(red: 105/255, green: 105/255, blue: 105/255, alpha: 1.0),
                                          "customRed": UIColor(red: 255/255, green: 203/255, blue: 219/255, alpha: 1.0) ]
        return someDict
    }
    
    static var customGray: UIColor {
        return UIColor(red: 105/255, green: 105/255, blue: 105/255, alpha: 1.0)
    }
}
