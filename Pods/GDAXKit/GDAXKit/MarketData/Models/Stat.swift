//
//  Stat.swift
//  c01ns
//
//  Created by Steve on 1/2/18.
//  Copyright © 2018 Steve Wight. All rights reserved.
//

import UIKit

public class Stat:Codable {
    public var open:String = ""
    public var high:String = ""
    public var low:String = ""
    public var volume:String = ""
    public var last:String = ""
    public var volume30Day:String = ""
    
    enum CodingKeys: String, CodingKey {
        case open, high, low, volume, last
        case volume30Day = "volume_30day"
    }
}
