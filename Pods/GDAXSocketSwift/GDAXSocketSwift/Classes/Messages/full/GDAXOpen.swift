//
//  GDAXOpen.swift
//  GDAXSocketSwift
//
//  Created by Hani Shabsigh on 10/29/17.
//  Copyright © 2017 Hani Shabsigh. All rights reserved.
//

import Foundation

public class GDAXOpen: GDAXProductSequenceTimeMessage {
    
    open let orderId: String
    open let price: Double
    open let remainingSize: Double
    open let side: GDAXSide
    
    public required init(json: [String: Any]) throws {
        
        guard let orderId = json["order_id"] as? String else {
            throw GDAXError.responseParsingFailure("order_id")
        }
        
        guard let price = Double(json["price"] as? String ?? "") else {
            throw GDAXError.responseParsingFailure("price")
        }
        
        guard let remainingSize = Double(json["remaining_size"] as? String ?? "") else {
            throw GDAXError.responseParsingFailure("remaining_size")
        }
        
        guard let side = GDAXSide(rawValue: json["side"] as? String ?? "") else {
            throw GDAXError.responseParsingFailure("side")
        }
        
        self.orderId = orderId
        self.remainingSize = remainingSize
        self.price = price
        self.side = side
        
        try super.init(json: json)
    }
}
