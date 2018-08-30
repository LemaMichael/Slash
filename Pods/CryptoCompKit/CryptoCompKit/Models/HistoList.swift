//
//  HistoList.swift
//  Vault
//
//  Created by Steve on 5/10/18.
//  Copyright © 2018 Steve Wight. All rights reserved.
//

import UIKit

public class HistoList:Codable, Response {
    public var histos = [HistoData]()
    
    enum CodingKeys: String, CodingKey {
        case histos = "Data"
    }
}
