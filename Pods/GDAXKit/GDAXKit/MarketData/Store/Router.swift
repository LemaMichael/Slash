//
//  Router.swift
//  c01ns
//
//  Created by Steve on 12/29/17.
//  Copyright © 2017 Steve Wight. All rights reserved.
//

import UIKit

protocol URLRequestProtocol {
    func url()->URL
}

enum Router:URLRequestProtocol {
    static let baseURL = "https://api.gdax.com"

    case products()
    case currencies()
    case book(productID:String,level:BookLevel)
    case ticker(productID:String)
    case trades(productID:String)
    case historic(productID:String,params:[String:String])
    case stats(productID:String)
    case time()
    
    public func request()->URLRequest {
        var request = URLRequest(url:url())
        request.httpMethod = "GET"
        return request
    }
    
    internal func url()->URL {
        var components = urlComponents()
        let items = paramItems()
        if !items.isEmpty {
            components.queryItems = items
        }
        return components.url!
    }
    
    private func urlComponents()->URLComponents {
        let url = Router.baseURL + path()
        return URLComponents(string: url)!
    }
    
    private func path()->String {
        switch self {
        case .products():
            return "/products"
        case .currencies():
            return "/currencies"
        case let .book(productID,_):
            return "/products/\(productID)/book"
        case let .ticker(productID):
            return "/products/\(productID)/ticker"
        case let .trades(productID):
            return "/products/\(productID)/trades"
        case let .historic(productID,_):
            return "/products/\(productID)/candles"
        case let .stats(productID):
            return "/products/\(productID)/stats"
        case .time():
            return "/time"
        }
    }
    
    private func paramItems()->[URLQueryItem] {
        switch self {
        case .products(),.currencies(),.time():
            return []
        case .ticker(_), .trades(_), .stats(_):
            return []
        case let .book(_,level):
            return buildParams(["level":String(level.rawValue)])
        case let .historic(_,params):
            return buildParams(params)
        }
    }
    
    private func buildParams(_ params:[String:String])->[URLQueryItem] {
        var items = [URLQueryItem]()
        for (key,value) in params {
            items.append(URLQueryItem(name: key, value: value))
        }
        return items.filter{!$0.name.isEmpty}
    }
    
}
