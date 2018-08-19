//
//  Currency.swift
//  c01ns
//
//  Created by Steve on 12/28/17.
//  Copyright © 2017 Steve Wight. All rights reserved.
//

import UIKit

public class Currency:Codable {
    public var id:String
    public var name:String
    public var minSize:String
    public var status:String
    public var message:String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, status, message
        case minSize = "min_size"
    }
    
    public init(id:String, name:String) {
        self.id = id
        self.name = name
        self.minSize = "0.0"
        self.status = "offline"
    }
    
}
