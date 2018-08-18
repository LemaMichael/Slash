//
//  GDAXDone.swift
//  GDAXSocketSwift
//
//  Created by Hani Shabsigh on 10/29/17.
//  Copyright © 2017 Hani Shabsigh. All rights reserved.
//

import Foundation

open class GDAXDone: GDAXProductSequenceTimeMessage {
    
    open let orderId: String
    open let price: Double?
    open let remainingSize: Double?
    open let side: GDAXSide
    open let reason: String
    
    public required init(json: [String: Any]) throws {
        
        guard let orderId = json["order_id"] as? String else {
            throw GDAXError.responseParsingFailure("order_id")
        }
        
        let price = Double(json["price"] as? String ?? "")
        
        let remainingSize = Double(json["remaining_size"] as? String ?? "")
        
        guard let side = GDAXSide(rawValue: json["side"] as? String ?? "") else {
            throw GDAXError.responseParsingFailure("side")
        }
        
        guard let reason = json["reason"] as? String else {
            throw GDAXError.responseParsingFailure("reason")
        }
        
        self.orderId = orderId
        self.remainingSize = remainingSize
        self.price = price
        self.side = side
        self.reason = reason
        
        try super.init(json: json)
    }
}
