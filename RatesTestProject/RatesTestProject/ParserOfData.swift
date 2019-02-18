//
//  ParserOfData.swift
//  RatesTestProject
//
//  Created by Dmitriy Opryatnov on 2/8/19.
//  Copyright © 2019 Dmitriy Opryatnov. All rights reserved.
//

import Foundation

struct CurrencyRates {
	//currencys.xml
	var numCode: String
	var charCode: String
	var scale: String
	var name: String
	var rate: String
}

protocol ParserOfDataDelegate: class {
	
	func didFinishParsing(items: [CurrencyRates])
	
}

class ParserOfData: NSObject, XMLParserDelegate {
	
	weak var parserDelegate: ParserOfDataDelegate?
	
	var resultItem = [CurrencyRates]()
	
	var elementName: String = String()
	var numCode = String()
	var charCode = String()
	var scale = String()
	var name = String()
	var rate = ""
	
	var currentElementName: String = ""
	
	func start(with data: Data) {
		let parser = XMLParser(data: data)
		parser.delegate = self
		parser.parse()
	}
	//1
	func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
		if elementName == "Currency" {
			
			numCode = String()
			charCode = String()
			scale = String()
			name = String()
			rate = ""
		}
		self.elementName = elementName
	}
	//2
	func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
		if elementName == "Currency" {
			let currency = CurrencyRates(numCode: numCode, charCode: charCode, scale: scale, name: name, rate: rate)
			resultItem.append(currency)
		}
	}
	//3
	func parser(_ parser: XMLParser, foundCharacters string: String) {
		let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
		
		if (!data.isEmpty) {
			switch self.elementName {
			case "NumCode":
				numCode = data
			case "CharCode":
				charCode = data
			case "Scale":
				scale = data
			case "Name":
				name = data
			case "Rate":
				rate = data
			default:
				break
			}
		}
	}
	
	func parserDidEndDocument(_ parser: XMLParser) {
		//print(resultItem)
		parserDelegate?.didFinishParsing(items: resultItem)
	}
}
