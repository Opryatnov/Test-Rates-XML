//
//  XmlParesrForRates.swift
//  Exchange Rates
//
//  Created by Dmitriy Opryatnov on 3/15/19.
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
    var cur_id: String
}

protocol XmlParserForRatesDelegate: class {
    
    func didFinishParsing(dataAfterParsing: [CurrencyRates])
    
}

class XmlParesrForRates: NSObject, XMLParserDelegate {
    
    weak var parserDelegate: XmlParserForRatesDelegate?
    var resultItem = [CurrencyRates]()
    var elementName: String = String()
    var numCode = String()
    var charCode = String()
    var scale = String()
    var name = String()
    var rate = ""
    var cur_id = ""
    var currentElementName: String = ""
    
    private let kCurrency = "Currency"
    
    func start(with data: Data) {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }
    //1
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        if elementName == kCurrency {
            numCode = String()
            charCode = String()
            scale = String()
            name = String()
            rate = ""
            cur_id = ""
        }
        self.elementName = elementName
    }
    //2
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == kCurrency {
            let currency = CurrencyRates(numCode: numCode, charCode: charCode, scale: scale, name: name, rate: rate, cur_id: cur_id)
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
            case "Cur_ID":
                cur_id = data
            default:
                break
            }
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        //print(resultItem)
        parserDelegate?.didFinishParsing(dataAfterParsing: resultItem)
    }
}
