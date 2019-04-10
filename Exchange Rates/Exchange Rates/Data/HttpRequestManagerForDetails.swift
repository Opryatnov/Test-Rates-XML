//
//  HttpRequestManagerForDetails.swift
//  Exchange Rates
//
//  Created by Dmitriy Opryatnov on 3/15/19.
//  Copyright © 2019 Dmitriy Opryatnov. All rights reserved.
//


import Foundation
import UIKit

//rename Rate
struct Rate: Decodable {
    let Cur_ID: Int
    let Date: String
    let Cur_OfficialRate: Double
    
    private enum CodingKeys: String, CodingKey {
        case Cur_ID
        case Date
        case Cur_OfficialRate
    }
}

//rename name protocol
protocol HttpRequestManagerForDetailsDelegate: class {
    func httpRequestSendData(data: [Rate])
    //   func httpRequestDidError(_ message: String)
    //  func httpResponseError(_ response: String)
}


//rename  class
class HttpRequestManagerForDetails {
    
    private var sendData = [Rate]()
    weak var delegate: HttpRequestManagerForDetailsDelegate?
    
    func httpRequest(date: String, currentDate: String) {
        //let str2 = "http://www.nbrb.by/API/ExRates/Currencies/145"
        let urlStr = "http://www.nbrb.by/API/ExRates/Rates/Dynamics/145?startDate=\(date)&endDate=\(currentDate)"
        guard let url = URL(string: urlStr) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared
        session.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            guard error == nil else { return }
            let decoder = JSONDecoder()
            
            do {
                let rate = try decoder.decode(Array<Rate>.self, from: data)
                // print(rate)
                self.sendData = rate
                DispatchQueue.main.async {
                    self.delegate?.httpRequestSendData(data: rate)
                    // print("send complete")
                    // print(rate)
                }
                
            } catch let error {
                print(error)
            }
            
            }.resume()
    }
}
