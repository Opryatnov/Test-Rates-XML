//
//  DetailsViewController.swift
//  Exchange Rates
//
//  Created by Dmitriy Opryatnov on 3/9/19.
//  Copyright © 2019 Dmitriy Opryatnov. All rights reserved.
//


import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var detailsTablerView: UITableView!
    @IBOutlet weak var currencyLable: UILabel!
    @IBOutlet weak var backButton: UIButton!
    var rateData: [Rate] = []
    let requestDetails = HttpRequestManagerForDetails()
    var text = ""
    var nameCurrency = ""
    var dateForRequest = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestDetails.delegate = self
        detailsTablerView.dataSource = self
        //detailsTablerView.backgroundColor = UIColor.darkGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestDetails.httpRequest(date: dateForRequest, currentDate: nameCurrency)
        currencyLable.text = "Динамика USD с \(dateForRequest) по \(nameCurrency)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @IBAction func backToRatesbuttonTaped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}

extension DetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rateData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellDetails = "Cell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellDetails, for: indexPath) as? DetailsTableViewCell else {
            fatalError("Can't initialize cell with identifier: \(cellDetails)")
        }
        
        let shadowPath2 = UIBezierPath(rect: cell.bounds)
        cell.layer.shadowPath = shadowPath2.cgPath
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 2
        cell.layer.shadowRadius = 10.0
        cell.layer.shadowOpacity = 1
        
        let someData = rateData[indexPath.row]
        cell.dataLabel.text = "На дату: \(someData.Date.trunc(10))"
        cell.dateLabel.text = "Курс: \(String(someData.Cur_OfficialRate))"
        //добавить новый лейбл для отображения кода валюты,
        // добавить наименование валюты - на лейбл между таблицей и кнопкой возврата
        /*
         * Не делай так больше!!! У тебя будет постоянно перезагружаться таблица
         */
        //        detailsTablerView.reloadData()
        return cell
    }
}

extension DetailsViewController: HttpRequestManagerForDetailsDelegate {
    func httpRequestSendData(data: [Rate]) {
        rateData = data
        print("catch data")
        //print(rateData)
        detailsTablerView.reloadData()
    }
}

extension String {
    
    func trunc(_ length: Int) -> String {
        if self.count > length {
            return self.substring(to: self.characters.index(self.startIndex, offsetBy: length))
        } else {
            return self
        }
    }
    
    func trim() -> String{
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
