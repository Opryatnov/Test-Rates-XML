//
//  ViewController.swift
//  RatesTestProject
//
//  Created by Dmitriy Opryatnov on 2/8/19.
//  Copyright © 2019 Dmitriy Opryatnov. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDelegate {
	
	var arrayOfDatas: [CurrencyRates] = []
	let mainStartClassApp = HttpRequest()
	
	@IBOutlet weak var mainTableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		mainStartClassApp.delegate = self
		mainTableView.dataSource = self
		super.view.addSubview(mainTableView)
		mainTableView.isEditing = true
		mainTableView.backgroundColor = UIColor.darkGray
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		mainStartClassApp.httpRequest()
	}
}

extension ViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return (arrayOfDatas.count)
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellId = "cell"
		guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? CustomTableViewCell else {
			fatalError("Can't initialize cell with identifier: \(cellId)")
		}
		
		let item = arrayOfDatas[indexPath.row]
		cell.backgroundColor = UIColor.gray
		cell.charCodeLabel.textColor = UIColor.white
		cell.charCodeLabel.text = item.name + " за " + item.scale + " ед."
		cell.nameLabel.textColor = UIColor.white
		cell.nameLabel.text = item.charCode + " " + item.rate + " BYN"
		return (cell)
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
		mainTableView.reloadData()
	}
}

extension ViewController: HttpRequestDelegate {
	
	func httpRequestDidError(_ message: String) {
		let alert = UIAlertController(title: "ERROR", message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
		self.mainStartClassApp.httpRequest()
		}))
		self.present(alert, animated: true, completion: nil)
	}
	
	func httpRequestDidLoadData(_ data: Data) {
		let parser = ParserOfData()
		parser.parserDelegate = self
		parser.start(with: data)
	}
}

extension ViewController: ParserOfDataDelegate {
	
	func didFinishParsing(dataAfterParsing: [CurrencyRates]) {
		arrayOfDatas = dataAfterParsing
		print(arrayOfDatas)
		mainTableView.reloadData()
	}
}
