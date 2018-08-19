//
//  Trade.swift
//  c01ns
//
//  Created by Steve on 1/2/18.
//  Copyright © 2018 Steve Wight. All rights reserved.
//

import UIKit

public class Trade:Codable {
    public var time:Date = Date()
    public var tradeID:Int = 0
    public var price:String = ""
    public var side:String = ""
    public var size:String = ""
    
    enum CodingKeys: String, CodingKey {
        case tradeID = "trade_id"
        case time, price, side, size
    }
}
