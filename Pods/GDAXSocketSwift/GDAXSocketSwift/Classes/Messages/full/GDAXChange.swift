//
//  GDAXChange.swift
//  GDAXSocketSwift
//
//  Created by Hani Shabsigh on 10/29/17.
//  Copyright © 2017 Hani Shabsigh. All rights reserved.
//

import Foundation

open class GDAXChange: GDAXProductSequenceTimeMessage {
    
    public let orderId: String
    public let newSize: Double?
    public let oldSize: Double?
    public let newFunds: Double?
    public let oldFunds: Double?
    public let price: Double
    public let side: GDAXSide
    
    public required init(json: [String: Any]) throws {
        
        guard let orderId = json["order_id"] as? String else {
            throw GDAXError.responseParsingFailure("order_id")
        }
        
        let newSize = Double(json["new_size"] as? String ?? "")
        
        let oldSize = Double(json["old_size"] as? String ?? "")
        
        let newFunds = Double(json["new_funds"] as? String ?? "")
        
        let oldFunds = Double(json["old_funds"] as? String ?? "")
        
        guard let price = Double(json["price"] as? String ?? "") else {
            throw GDAXError.responseParsingFailure("price")
        }
        
        guard let side = GDAXSide(rawValue: json["side"] as? String ?? "") else {
            throw GDAXError.responseParsingFailure("side")
        }
        
        self.orderId = orderId
        self.newSize = newSize
        self.oldSize = oldSize
        self.newFunds = newFunds
        self.oldFunds = oldFunds
        self.price = price
        self.side = side
        
        try super.init(json: json)
    }
}
