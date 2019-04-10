//
//  CalculateViewController.swift
//  Exchange Rates
//
//  Created by Dmitriy Opryatnov on 3/9/19.
//  Copyright © 2019 Dmitriy Opryatnov. All rights reserved.
//

import UIKit

class CalculateViewController: UIViewController {
    let value = UserDefaults.standard.value(forKey: "calc") as? [String: String]
    var someDict: [String: String] = [:]
    var currency: String = ""
    var result: Double = 0
    var firstValue: String = ""
    var secondValue: String = ""
    @IBOutlet weak var firstValueTextField: UITextField!
    
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var resultButton: UIButton!
    
    @IBOutlet var currencyButton: [UIButton]!
    
    @IBOutlet weak var resultLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func resultButtonPressed(_ sender: UIButton) {
        //result
        if let text = firstValueTextField.text, text != "" {
            firstValue = text
        } else {
            firstValue = "0"
        }
        
        if currency != "" {
            secondValue = currency
        } else {
            secondValue = "0"
        }
        
        result = Double(String(firstValue))! / Double(secondValue)!
        let newResult = Double(round(100*result)/100)
        resultLabel.text = String(newResult)
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let newValue = value {
            someDict = newValue
        }
    }
    
    @IBAction func selection(_ sender: UIButton) {
        currencyButton.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                if button.isHidden == true {
                    button.isHidden = false
                    self.firstValueTextField.isHidden = true
                    self.resultButton.isHidden = true
                    self.resultLabel.isHidden = true
                } else {
                    button.isHidden = true
                    
                    self.firstValueTextField.isHidden = false
                    self.resultButton.isHidden = false
                    self.resultLabel.isHidden = false
                }
                self.view.layoutIfNeeded()
            })
        }
    }
    
    enum Currencys: String {
        case USD = "USD"
        case EUR = "EUR"
        case RUB = "RUB"
    }
    
    @IBAction func currencyTaped(_ sender: UIButton) {
        
        self.firstValueTextField.isHidden = false
        self.resultButton.isHidden = false
        self.resultLabel.isHidden = false
        
        guard let title = sender.currentTitle,let currencys = Currencys(rawValue: title) else {
            return
        }
        
        for (key, value) in someDict {
            switch currencys {
            case .USD:
                if key == "USD" {
                    print(value)
                    // print(someDict["USD"])
                    currency = value
                    selectButton.titleLabel?.text = "BYN " + "To " + "USD"
                }
                
            case .EUR:
                if key == "EUR" {
                    print(value)
                    currency = value
                    // print(someDict["USD"])
                    selectButton.titleLabel?.text = "BYN " + "To " + "EUR"
                }
            case .RUB:
                if key == "RUB" {
                    // print(value)
                    let s = Double(value)! * 100
                    currency = String(s)
                    // print(someDict["USD"])
                    selectButton.titleLabel?.text = "BYN " + "To " + "RUB"
                }
            }
        }
        
        currencyButton.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
            
        }
    }
}
