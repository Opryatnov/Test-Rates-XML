//
//  HttpRequest.swift
//  RatesTestProject
//
//  Created by Dmitriy Opryatnov on 2/8/19.
//  Copyright © 2019 Dmitriy Opryatnov. All rights reserved.
//

import Foundation
import Reachability

protocol HttpRequestDelegate: class {
	
	func httpRequestDidError(_ message: String)
	func httpRequestDidLoadData(_ data: Data)
}

class HttpRequest {
	
	weak var delegate: HttpRequestDelegate?
	
	func httpRequest() {
		
		let reachability = Reachability(hostName: "google.com")
		if !(reachability?.isReachable() ?? false) {
			//TODO: return error
			delegate?.httpRequestDidError("No network connection")
			print("network error")
			return
		}
		
		let urlStr = "http://www.nbrb.by/Services/XmlExRates.aspx"
		guard let url = URL(string: urlStr) else {
			return
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		let session = URLSession.shared
		session.dataTask(with: url) { (data, response, error) in
			if let data = data {
				DispatchQueue.main.async {
					self.delegate?.httpRequestDidLoadData(data)
				}
			}
			
			guard data != nil else { return }
			} .resume()
	}
}
