//
//  RatesViewController.swift
//  Exchange Rates
//
//  Created by Dmitriy Opryatnov on 3/9/19.
//  Copyright © 2019 Dmitriy Opryatnov. All rights reserved.
//

import UIKit


class RatesViewController: UIViewController {
    
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var datePickerViewTopSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var chooseDatePicker: UIDatePicker!
    
    var resultOfChooseDatePicker: String? = nil
    
    let segueId = "GoToDetailsViewControllerSegue"
    var currencyId = ""
    var currencyName = ""
    var requestDate = ""
    var currentDate = ""
    
    let requestRates = HttpRequest()
    var arrayOfDatas: [CurrencyRates] = []
    var saveDataForCalculate: [String: String] = [:]
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(RatesViewController.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.blue
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isEditing = false
        requestRates.delegate = self
        dateField.inputView = UIView()
        requestRates.httpRequest()
//        self.tableView.addSubview(self.refreshControl)
        self.tableView.refreshControl = self.refreshControl
        tableView.reloadData()
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.requestRates.httpRequest()
        refreshControl.endRefreshing()
    }
    
    func showCurrentDtae() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-M-d"
        currentDate = formatter.string(from: date)
        return currentDate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        okButton.backgroundColor = .customGray
        dateField.backgroundColor = UIColor.lightGray
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestRates.httpRequest()
    }
    
    weak var delegate: DetailsViewController?
    
    //Edit button pressed for D&D cells
    @IBAction func editButtonTaped(_ sender: UIButton) {
        if tableView.isEditing == false {
            tableView.isEditing = true
            editButton.setTitle("Save", for: .normal)
            tableView.reloadData()
        } else {
            tableView.isEditing = false
            editButton.setTitle("Edit", for: .normal)
            tableView.reloadData()
        }
    }
    
    //Move Cells ---------------------------
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.arrayOfDatas[sourceIndexPath.row]
        arrayOfDatas.remove(at: sourceIndexPath.row)
        arrayOfDatas.insert(movedObject, at: destinationIndexPath.row)
        //self.tableView.addSubview(self.refreshControl)
        
        tableView.reloadData()
    } //End Move Cells
    
    //Send some data to DetailsViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueId, let vc = segue.destination as? DetailsViewController {
            // vc.text = currencyId
            guard let date = dateField.text else {return}
            vc.nameCurrency = showCurrentDtae()
            requestDate = date
            vc.dateForRequest = requestDate
            //vc.nameCurrency = currencyName
        }
    }
    
    //Show date picker to choose date
    func showDatePicker() {
        UIView.animate(withDuration: 0.3) {
            self.datePickerViewTopSpaceConstraint.priority = .defaultLow
            self.view.layoutIfNeeded()
        }
    }
    
    func hideDatePicker() {
        UIView.animate(withDuration: 0.3) {
            self.datePickerViewTopSpaceConstraint.priority = .defaultHigh
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func saveDateFromDatePickerTapped(_ sender: UIButton) {
        let requestDateFormat = DateFormatter()
        requestDateFormat.dateFormat = "YYYY-M-d"
        dateField.text = requestDateFormat.string(from: (chooseDatePicker?.date)!)
        dateField.endEditing(true)
        hideDatePicker()
    }
}

extension RatesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayOfDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "Cell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? RatesCellTableViewCell else {
            fatalError("Can't initialize cell with identifier: \(cellId)")
        }
        
        let shadowPath2 = UIBezierPath(rect: cell.bounds)
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 2
        cell.layer.masksToBounds = true
        cell.layer.shadowRadius = 10.0
        cell.layer.shadowOpacity = 1
        cell.layer.shadowPath = shadowPath2.cgPath
        
        let item = arrayOfDatas[indexPath.row]
        cell.infoLabel.text = item.name + " за " + item.scale + " ед."
        cell.dataLabel.text = item.charCode + " " + item.rate + " BYN"
        return (cell)
    }
}



extension RatesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected \(indexPath)")
        
        if let cell = tableView.cellForRow(at: indexPath) as? RatesCellTableViewCell {
            let info = cell.infoLabel.text
            let date = cell.dataLabel.text
            let items = arrayOfDatas[indexPath.row]
            if items.charCode != nil {
                var array: [String] = []
                array.append(items.charCode)
                for s in array {
                    switch s {
                    case "USD":
                        // print(s)
                        currencyId = "145"
                        currencyName = "USD"
                    case "RUB":
                        // print(s)
                        currencyId = "643"
                        currencyName = "RUB"
                    case "PLN":
                        //print(s)
                        currencyId = "219"
                        currencyName = "PLN"
                    case "GBP":
                        currencyId = "143"
                        currencyName = "GBP"
                    case "CNY":
                        currencyId = "250"
                        currencyName = "CNY"
                    case "UAH":
                        currencyId = "224"
                        currencyName = "UAH"
                    case "AUD":
                        currencyId = "170"
                        currencyName = "AUD"
                    case "BGN":
                        currencyId = "975"
                        currencyName = "BGN"
                    case "DKK":
                        currencyId = "208"
                        currencyName = "DKK"
                    case "EUR":
                        currencyId = "19"
                        currencyName = "EUR"
                    case "IRR":
                        currencyId = "61"
                        currencyName = "IRR"
                        
                    default:
                        print("other")
                    }
                    
                }
                
                // print("item.name -------------------- \(array)--------------")
            } else {
                print("not found")
            }
            performSegue(withIdentifier: segueId, sender: nil)
        }
    }
}

extension RatesViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showDatePicker()
    }
}

extension RatesViewController: HttpRequestManagerForRatesDelegate {
    
    func httpRequestDidError(_ message: String) {
        let alert = UIAlertController(title: "ERROR", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            //self.requestRates.httpRequest()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func httpResponseError(_ message: String) {
        let alert = UIAlertController(title: "ERROR", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func httpRequestDidLoadData(_ data: Data) {
        let parser = XmlParesrForRates()
        parser.parserDelegate = self
        parser.start(with: data)
    }
}

extension RatesViewController: XmlParserForRatesDelegate {
    
    func didFinishParsing(dataAfterParsing: [CurrencyRates]) {
        arrayOfDatas = dataAfterParsing
        //print(arrayOfDatas)
        let array = arrayOfDatas
        for value in array {
            switch  value.charCode {
            case "USD":
                saveDataForCalculate.updateValue(value.rate, forKey: "USD")
            //print(saveDataForCalculate)
            case "EUR":
                saveDataForCalculate.updateValue(value.rate, forKey: "EUR")
            case "RUB":
                saveDataForCalculate.updateValue(value.rate, forKey: "RUB")
            default:
                break
            }
        }
        
        UserDefaults.standard.set(saveDataForCalculate, forKey: "calc")
        let saved = UserDefaults.standard.value(forKey: "calc") as? [String: String]
        if let newValue = saved {
            print(newValue)
        }
        tableView.reloadData()
    }
}





