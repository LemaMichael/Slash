//
//  GDAXSubscriptions.swift
//  GDAXSocketSwift
//
//  Created by Hani Shabsigh on 10/29/17.
//  Copyright © 2017 Hani Shabsigh. All rights reserved.
//

import Foundation

open class GDAXSubscriptions: GDAXMessage {
    
    public let channels: [GDAXSubscription]
    
    public required init(json: [String: Any]) throws {
        
        guard let channelJSONs = json["channels"] as? [[String: Any]] else {
            throw GDAXError.responseParsingFailure("subscriptions_channels")
        }
        
        var channelObjects = [GDAXSubscription]()
        for channelJSON in channelJSONs {
            guard let channel = try? GDAXSubscription(json: channelJSON) else {
                throw GDAXError.responseParsingFailure("subscriptions_channel")
            }
            
            channelObjects.append(channel)
        }
        
        self.channels = channelObjects
        
        try super.init(json: json)
    }
}
