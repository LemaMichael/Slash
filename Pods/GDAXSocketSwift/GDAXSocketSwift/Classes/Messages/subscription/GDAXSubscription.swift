//
//  GDAXSubscription.swift
//  GDAXSocketSwift
//
//  Created by Hani Shabsigh on 10/29/17.
//  Copyright © 2017 Hani Shabsigh. All rights reserved.
//

import Foundation

open class GDAXSubscription {
    
    open let channel:GDAXChannel
    open let productIds:[GDAXProductId]
    
    public init(json: [String: Any]) throws {
        
        guard let channel = GDAXChannel(rawValue: json["name"] as? String ?? "") else {
            throw GDAXError.responseParsingFailure("subscription_name")
        }
        
        guard let productIdStrings = json["product_ids"] as? [String] else {
            throw GDAXError.responseParsingFailure("subscription_product_ids")
        }
        
        var productIdObjects = [GDAXProductId]()
        for productIdString in productIdStrings {
            guard let productId = GDAXProductId(rawValue: productIdString) else {
                throw GDAXError.responseParsingFailure("subscription_product_id")
            }
            
            productIdObjects.append(productId)
        }
        
        self.channel = channel
        self.productIds = productIdObjects
    }
}
