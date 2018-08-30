//
//  CoinData.swift
//  Vault
//
//  Created by Steve on 5/9/18.
//  Copyright © 2018 Steve Wight. All rights reserved.
//

import UIKit

public class CoinData:Codable {
    public var id = ""
    public var url = ""
    public var imageURL:String?
    public var name = ""
    public var symbol = ""
    public var coinName = ""
    public var fullName = ""
    public var algorithm = ""
    public var proofType = ""
    public var sortOrder = ""
    
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case url = "Url"
        case imageURL = "ImageUrl"
        case name = "Name"
        case symbol = "Symbol"
        case coinName = "CoinName"
        case fullName = "FullName"
        case algorithm = "Algorithm"
        case proofType = "ProofType"
        case sortOrder = "SortOrder"
    }
    
}
