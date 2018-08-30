//
//  PriceList.swift
//  Vault
//
//  Created by Steve on 5/10/18.
//  Copyright © 2018 Steve Wight. All rights reserved.
//

import UIKit

public class PriceList:Codable, Response {
    public var prices = [String:[String:PriceData]]()

    enum CodingKeys: String, CodingKey {
        case prices = "RAW"
    }
}
