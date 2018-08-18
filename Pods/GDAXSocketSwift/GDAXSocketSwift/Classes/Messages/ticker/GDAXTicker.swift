//
//  GDAXTicker.swift
//  GDAXSocketSwift
//
//  Created by Hani Shabsigh on 10/29/17.
//  Copyright © 2017 Hani Shabsigh. All rights reserved.
//

import Foundation

open class GDAXTicker: GDAXProductSequenceTimeMessage {
    
    open let tradeId: Int?
    open let price: Double
    open let side: GDAXSide?
    open let lastSize: Double?
    open let bestBid: Double
    open let bestAsk: Double
    open let open24h: Double
    open let high24h: Double
    open let low24h: Double
    open let volume24h: Double
    open let volume30d: Double
    
    public required init(json: [String: Any]) throws {
        
        let tradeId = json["trade_id"] as? Int
        
        guard let price = Double(json["price"] as? String ?? "") else {
            throw GDAXError.responseParsingFailure("price")
        }
        
        let side = GDAXSide(rawValue: json["side"] as? String ?? "")
        
        let lastSize = Double(json["last_size"] as? String ?? "")
        
        guard let bestBid = Double(json["best_bid"] as? String ?? "") else {
            throw GDAXError.responseParsingFailure("best_bid")
        }
        
        guard let bestAsk = Double(json["best_ask"] as? String ?? "") else {
            throw GDAXError.responseParsingFailure("best_ask")
        }
        
        guard let open24h = Double(json["open_24h"] as? String ?? "") else {
            throw GDAXError.responseParsingFailure("open_24h")
        }
        
        guard let high24h = Double(json["high_24h"] as? String ?? "") else {
            throw GDAXError.responseParsingFailure("high_24h")
        }
        
        guard let low24h = Double(json["low_24h"] as? String ?? "") else {
            throw GDAXError.responseParsingFailure("low_24h")
        }
        
        guard let volume24h = Double(json["volume_24h"] as? String ?? "") else {
            throw GDAXError.responseParsingFailure("volume_24h")
        }
        
        guard let volume30d = Double(json["volume_30d"] as? String ?? "") else {
            throw GDAXError.responseParsingFailure("volume_30d")
        }
        
        self.tradeId = tradeId
        self.price = price
        self.side = side
        self.lastSize = lastSize
        self.bestBid = bestBid
        self.bestAsk = bestAsk
        self.open24h = open24h
        self.high24h = high24h
        self.low24h = low24h
        self.volume24h = volume24h
        self.volume30d = volume30d
        
        try super.init(json: json)
    }    
}
