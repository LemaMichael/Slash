//
//  Ticker.swift
//  c01ns
//
//  Created by Steve on 1/2/18.
//  Copyright © 2018 Steve Wight. All rights reserved.
//

import UIKit

public class Ticker:Codable {
    public var tradeID:Int = 0
    public var price:String = ""
    public var size:String = ""
    public var bid:String = ""
    public var ask:String = ""
    public var volume:String = ""
    public var time:Date = Date()
    
    enum CodingKeys: String, CodingKey {
        case tradeID = "trade_id"
        case price, size, bid, ask, volume, time
    }
}
