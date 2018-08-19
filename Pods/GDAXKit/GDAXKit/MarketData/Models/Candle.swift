//
//  Candle.swift
//  c01ns
//
//  Created by Steve on 1/7/18.
//  Copyright © 2018 Steve Wight. All rights reserved.
//

import UIKit

public class Candle:Codable {
    public let time:Date
    public let low:Double
    public let high:Double
    public let open:Double
    public let close:Double
    public let volume:Double
    
    public required init(from decoder:Decoder) throws {
        var container = try decoder.unkeyedContainer()
        time = try container.decode(Date.self)
        low = try container.decode(Double.self)
        high = try container.decode(Double.self)
        open = try container.decode(Double.self)
        close = try container.decode(Double.self)
        volume = try container.decode(Double.self)
    }
}
