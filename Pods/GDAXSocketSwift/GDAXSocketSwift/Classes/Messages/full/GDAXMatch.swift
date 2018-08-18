//
//  GDAXMatch.swift
//  GDAXSocketSwift
//
//  Created by Hani Shabsigh on 10/29/17.
//  Copyright © 2017 Hani Shabsigh. All rights reserved.
//

import Foundation

public class GDAXMatch: GDAXProductSequenceTimeMessage {
    
    open let tradeId: Int
    open let makerOrderId: String
    open let takerOrderId: String
    open let size: Double
    open let price: Double
    open let side: GDAXSide
    
    open let takerUserId: String?
    open let userId: String?
    open let takerProfileId: String?
    open let profileId: String?
    
    public required init(json: [String: Any]) throws {
        
        guard let tradeId = json["trade_id"] as? Int else {
            throw GDAXError.responseParsingFailure("trade_id")
        }
        
        guard let makerOrderId = json["maker_order_id"] as? String else {
            throw GDAXError.responseParsingFailure("maker_order_id")
        }
        
        guard let takerOrderId = json["taker_order_id"] as? String else {
            throw GDAXError.responseParsingFailure("taker_order_id")
        }
        
        guard let size = Double(json["size"] as? String ?? "") else {
            throw GDAXError.responseParsingFailure("size")
        }
        
        guard let price = Double(json["price"] as? String ?? "") else {
            throw GDAXError.responseParsingFailure("price")
        }
        
        guard let side = GDAXSide(rawValue: json["side"] as? String ?? "") else {
            throw GDAXError.responseParsingFailure("side")
        }
        
        self.tradeId = tradeId
        self.makerOrderId = makerOrderId
        self.takerOrderId = takerOrderId
        self.size = size
        self.price = price
        self.side = side
        
        self.takerUserId = json["taker_user_id"] as? String
        self.userId = json["user_id"] as? String
        self.takerProfileId = json["taker_profile_id"] as? String
        self.profileId = json["profile_id"] as? String
        
        try super.init(json: json)
    }
}
