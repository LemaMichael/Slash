//
//  GDAXHeartbeat.swift
//  GDAXSocketSwift
//
//  Created by Hani Shabsigh on 10/27/17.
//  Copyright © 2017 Hani Shabsigh. All rights reserved.
//

import Foundation

open class GDAXHeartbeat: GDAXProductSequenceTimeMessage {
    
    open let lastTradeId: Int
    
    public required init(json: [String: Any]) throws {

        guard let lastTradeId = json["last_trade_id"] as? Int else {
            throw GDAXError.responseParsingFailure("last_trade_id")
        }
        
        self.lastTradeId = lastTradeId
        
        try super.init(json: json)
    }
}
