//
//  HttpRequestManagerForRates.swift
//  Exchange Rates
//
//  Created by Dmitriy Opryatnov on 3/15/19.
//  Copyright © 2019 Dmitriy Opryatnov. All rights reserved.
//

import Foundation
import Reachability

protocol HttpRequestManagerForRatesDelegate: class {
    
    func httpRequestDidError(_ message: String)
    func httpRequestDidLoadData(_ data: Data)
    func httpResponseError(_ response: String)
}

class HttpRequest {
    var dataForSendRequest = ""
    weak var delegate: HttpRequestManagerForRatesDelegate?
    
    func httpRequest() {
        let reachability = Reachability(hostName: "google.com")
        if !(reachability?.isReachable() ?? false) {
            //TODO: return error
            delegate?.httpRequestDidError("No network connection")
            return
        }
        
        //Send request if date is empty Case by Default, if date is date - send request with parameters
        switch dataForSendRequest {
        case "":
            print(dataForSendRequest)
        default:
            print("Empty")
        }
        
        let urlStr = "http://www.nbrb.by/Services/XmlExRates.aspx"
        // let urlStr = "http://www.nbrb.by/API/ExRates/Rates?Periodicity=0"
        guard let url = URL(string: urlStr) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            //            print(response)
            //            print(data)
            if let data = data {
                //print(data)
                if error != nil {
                    self.delegate?.httpRequestDidError("Server return error, try send request later")
                    print(error?.localizedDescription as Any)
                }
                
                DispatchQueue.main.async {
                    self.delegate?.httpRequestDidLoadData(data)
                }
            }
            
            guard data != nil else { return }
            
            } .resume()
    }
}
