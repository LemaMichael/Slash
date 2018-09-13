//
//  GDAXReceived.swift
//  GDAXSocketSwift
//
//  Created by Hani Shabsigh on 10/29/17.
//  Copyright © 2017 Hani Shabsigh. All rights reserved.
//

import Foundation

open class GDAXReceived: GDAXProductSequenceTimeMessage {
    
    public let orderId: String
    public let size: Double?
    public let price: Double?
    public let side: GDAXSide
    public let orderType: GDAXOrderType
    public let funds: Double?
    
    public required init(json: [String: Any]) throws {
        
        guard let orderId = json["order_id"] as? String else {
            throw GDAXError.responseParsingFailure("order_id")
        }

        let size = Double(json["size"] as? String ?? "")
        
        let price = Double(json["price"] as? String ?? "")
        
        guard let side = GDAXSide(rawValue: json["side"] as? String ?? "") else {
            throw GDAXError.responseParsingFailure("side")
        }
        
        guard let orderType = GDAXOrderType(rawValue: json["order_type"] as? String ?? "") else {
            throw GDAXError.responseParsingFailure("order_type")
        }
        
        let funds = Double(json["funds"] as? String ?? "")

        self.orderId = orderId
        self.size = size
        self.price = price
        self.side = side
        self.orderType = orderType
        self.funds = funds
        
        try super.init(json: json)
    }
}
