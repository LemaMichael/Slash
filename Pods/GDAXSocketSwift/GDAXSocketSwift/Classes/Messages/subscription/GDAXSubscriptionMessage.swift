//
//  GDAXSubscription.swift
//  GDAXSocketSwift
//
//  Created by Hani Shabsigh on 10/29/17.
//  Copyright © 2017 Hani Shabsigh. All rights reserved.
//

import Foundation

open class GDAXSubscriptionMessage {
    
    public let channels: [GDAXChannel]
    public let productIds: [GDAXProductId]
    
    public init(channels:[GDAXChannel], productIds:[GDAXProductId]) {
        self.channels = channels
        self.productIds = productIds
    }
    
    open func subscribeJSON(type: GDAXType, channels:[GDAXChannel], productIds:[GDAXProductId]) -> [String : Any] {
        let channels = self.channels.map { $0.rawValue }
        let productIds = self.productIds.map { $0.rawValue }
        
        var json = [String:Any]()
        json["type"] = type.rawValue
        json["product_ids"] = productIds
        json["channels"] = channels
        return json
    }
}
