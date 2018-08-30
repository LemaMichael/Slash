//
//  Factory.swift
//  Vault
//
//  Created by Steve on 5/9/18.
//  Copyright © 2018 Steve Wight. All rights reserved.
//
import UIKit

enum Factory {
    case coinList
    case priceList
    case histoMinute
    
    public func build(_ data:Data)->Response {
        do {
            switch self {
            case .coinList:
                let response = try decoder().decode(CoinList.self, from: data)
                return response
            case .priceList:
                let response = try decoder().decode(PriceList.self, from: data)
                return response
            case .histoMinute:
                let response = try decoder().decode(HistoList.self, from: data)
                return response
            }
        } catch let error {
            dump(error)
        }
        return BlankResponse()
    }
    
    private func decoder()->JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .secondsSince1970
        return jsonDecoder
    }
    
}
