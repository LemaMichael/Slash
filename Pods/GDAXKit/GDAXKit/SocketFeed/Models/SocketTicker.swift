//
//  SocketTicker.swift
//  c01ns
//
//  Created by Steve on 1/5/18.
//  Copyright © 2018 Steve Wight. All rights reserved.
//

import UIKit

public class SocketTicker:Decodable {
    public var tradeID:Int = 0
    public var sequence:Int = 0
    public var productID:String = ""
    public var price:String = ""
    public var open24h:String = ""
    public var volume24h:String = ""
    public var low24h:String = ""
    public var high24h:String = ""
    public var volume30d:String = ""
    public var bestBid:String = ""
    public var bestAsk:String = ""
    public var side:String = ""
    public var time:Date = Date()
    public var lastSize:String = ""
    
    enum CodingKeys:String, CodingKey {
        case tradeID = "trade_id"
        case productID = "product_id"
        case sequence, price
        case open24h = "open_24h"
        case volume24h = "volume_24h"
        case low24h = "low_24h"
        case high24h = "high_24h"
        case volume30d = "volume_30d"
        case bestBid = "best_bid"
        case bestAsk = "best_ask"
        case side = "side"
        case time = "time"
        case lastSize = "last_size"
    }
    
}
