//
//  Request.swift
//  GDAXKit
//
//  Created by Steve on 1/18/18.
//  Copyright © 2018 Steve Wight. All rights reserved.
//

import UIKit

enum RequestError: Error {
    case statusCode
    case response
}

class Request {

    let baseURL = "https://api.gdax.com"
    let session = URLSession.shared
    var dataTask: URLSessionDataTask?
    
    public func run(router:Router,
                    factory:Factory,
                    complete:@escaping (_ result:Result<Any>)->Void) {
        
        dataTask = session.dataTask(with: router.request()) { data, response, error in
            let response = response as? HTTPURLResponse
            let result:Result<Any>!
            
            if response?.statusCode == 200 {
                let items = factory.build(data!)
                result = Result.success(items)
            } else {
                print("Incorrect status code")
                result = Result.failure(RequestError.statusCode)
            }
            complete(result)
        }
        dataTask?.resume()
    }
    
}
