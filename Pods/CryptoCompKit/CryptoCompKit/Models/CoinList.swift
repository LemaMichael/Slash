//
//  CoinList.swift
//  Vault
//
//  Created by Steve on 5/10/18.
//  Copyright © 2018 Steve Wight. All rights reserved.
//

import UIKit

public class CoinList:Codable, Response {
    public var coins = [String:CoinData]()
    public var baseImageURL = ""
    public var baseLinkURL = ""
    
    enum CodingKeys: String, CodingKey {
        case coins = "Data"
        case baseImageURL = "BaseImageUrl"
        case baseLinkURL = "BaseLinkUrl"
    }
}
