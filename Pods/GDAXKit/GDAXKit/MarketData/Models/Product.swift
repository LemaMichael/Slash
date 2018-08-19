//
//  Product.swift
//  c01ns
//
//  Created by Steve on 12/28/17.
//  Copyright © 2017 Steve Wight. All rights reserved.
//

import UIKit

public class Product:Codable {
    public let id:String
    public let baseCurrency:String
    public let quoteCurrency:String
    public let baseMinSize:String
    public let baseMaxSize:String
    public let quoteIncrement:String
    public let displayName:String
    public let status:String
    public let marginEnabled:Bool
    public let statusMessage:String?
    
    enum CodingKeys: String, CodingKey {
        case id, status
        case baseCurrency = "base_currency"
        case quoteCurrency = "quote_currency"
        case baseMinSize = "base_min_size"
        case baseMaxSize = "base_max_size"
        case quoteIncrement = "quote_increment"
        case displayName = "display_name"
        case marginEnabled = "margin_enabled"
        case statusMessage = "status_message"
    }
    
    public init(pid:String) {
        id = pid
        baseCurrency = ""
        quoteCurrency = ""
        baseMinSize = ""
        baseMaxSize = ""
        quoteIncrement = ""
        displayName = ""
        status = ""
        marginEnabled = false
        statusMessage = ""
    }
}
