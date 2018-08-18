//
//  GDAXSnapshot.swift
//  GDAXSocketSwift
//
//  Created by Hani Shabsigh on 10/29/17.
//  Copyright © 2017 Hani Shabsigh. All rights reserved.
//

open class GDAXSnapshot: GDAXProductMessage {
    
    open let bids: [GDAXBidAsk]
    open let asks: [GDAXBidAsk]
    
    public required init(json: [String: Any]) throws {

        guard let bids = json["bids"] as? [[String]] else {
            throw GDAXError.responseParsingFailure("bids")
        }
        
        guard let asks = json["asks"] as? [[String]] else {
            throw GDAXError.responseParsingFailure("asks")
        }
        
        var bidObjects = [GDAXBidAsk]()
        for bid in bids {
            guard let price = Double(bid[0]) else {
                throw GDAXError.responseParsingFailure("bid_price")
            }
            
            guard let size = Double(bid[1]) else {
                throw GDAXError.responseParsingFailure("bid_size")
            }
            
            bidObjects.append(GDAXBidAsk(type: .bid, price: price, size: size))
        }
        
        var askObjects = [GDAXBidAsk]()
        for ask in asks {
            guard let price = Double(ask[0]) else {
                throw GDAXError.responseParsingFailure("ask_price")
            }
            
            guard let size = Double(ask[1]) else {
                throw GDAXError.responseParsingFailure("ask_size")
            }
            
            askObjects.append(GDAXBidAsk(type: .ask, price: price, size: size))
        }
        
        self.bids = bidObjects
        self.asks = askObjects
        
        try super.init(json: json)
    }
}
