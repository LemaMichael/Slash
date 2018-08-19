//
//  Factory.swift
//  c01ns
//
//  Created by Steve on 12/28/17.
//  Copyright © 2017 Steve Wight. All rights reserved.
//

import UIKit

enum Factory {
    
    case products()
    case currencies()
    case book()
    case ticker()
    case trades()
    case historic()
    case stats()
    case time()
    
    public func build(_ data:Data)->[Any] {
        var items = [Any]()
        do {
            switch self {
            case .products():
                items = try decoder().decode([Product].self, from: data)
            case .currencies():
                items = try decoder().decode([Currency].self, from: data)
            case .book():
                let item = try decoder().decode(Book.self, from: data)
                items.append(item)
            case .ticker():
                let item = try decoder().decode(Ticker.self, from: data)
                items.append(item)
            case .trades():
                items = try decoder().decode([Trade].self, from: data)
            case .historic():
                items = try decoder().decode([Candle].self, from: data)
            case .stats():
                let item = try decoder().decode(Stat.self, from: data)
                items.append(item)
            case .time():
                let item = try decoder().decode(ServerTime.self, from: data)
                items.append(item)
            }
        } catch {
            print("Error decoding items: \(error)")
        }
        return items
    }
    
    private func decoder()->JSONDecoder {
        let jsonDecoder = JSONDecoder()
        switch self {
        case .historic():
            jsonDecoder.dateDecodingStrategy = .secondsSince1970
        default:
            jsonDecoder.dateDecodingStrategy = .custom({ (decoder)-> Date in
                return decoder.iso8601Custom()
            })
        }
        return jsonDecoder
    }
    
}
