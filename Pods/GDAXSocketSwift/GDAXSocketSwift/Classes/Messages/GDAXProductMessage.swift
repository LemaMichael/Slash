//
//  GDAXProductMessage.swift
//  GDAXSocketSwift
//
//  Created by Hani Shabsigh on 10/29/17.
//  Copyright © 2017 Hani Shabsigh. All rights reserved.
//

import Foundation

open class GDAXProductMessage: GDAXMessage {
    
    open let productId: GDAXProductId

    public required init(json: [String: Any]) throws {
        
        guard let productId = GDAXProductId(rawValue: json["product_id"] as? String ?? "") else {
            throw GDAXError.responseParsingFailure("product_id")
        }
        
        self.productId = productId
        
        try super.init(json: json)
    }
}
