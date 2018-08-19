//
//  SocketChannel.swift
//  c01ns
//
//  Created by Steve on 1/4/18.
//  Copyright © 2018 Steve Wight. All rights reserved.
//

import UIKit

enum SocketChannelType:String {
    case ticker = "ticker"
    case heartbeat = "heartbeat"
    case level2 = "level2"
}

class SocketChannel:Encodable {
    var type:SocketChannelType
    let name:String
    let productIDs:[String]
    
    enum CodingKeys:String, CodingKey {
        case name
        case productIDs = "product_ids"
    }
    
    init(type:SocketChannelType,productIDs:[String]) {
        self.name = type.rawValue
        self.productIDs = productIDs
        self.type = type
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey:.name)
        try container.encode(productIDs, forKey:.productIDs)
    }
}
