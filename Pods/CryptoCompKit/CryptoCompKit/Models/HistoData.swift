//
//  HistoData.swift
//  Vault
//
//  Created by Steve on 5/9/18.
//  Copyright © 2018 Steve Wight. All rights reserved.
//

import UIKit

public class HistoData:Codable {
    public var time = Date()
    public var close = 0.0
    public var high = 0.0
    public var low = 0.0
    public var open = 0.0
    public var volumeFrom = 0.0
    public var volumeTo = 0.0
    
    enum CodingKeys: String, CodingKey {
        case time = "time"
        case close = "close"
        case high = "high"
        case low = "low"
        case open = "open"
        case volumeFrom = "volumefrom"
        case volumeTo = "volumeto"
    }
}
