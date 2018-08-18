//
//  GDAXBidAsk.swift
//  GDAXSocketSwift
//
//  Created by Hani Shabsigh on 10/29/17.
//  Copyright © 2017 Hani Shabsigh. All rights reserved.
//

import Foundation

public enum GDAXBidAskType: String {
    
    case bid, ask
}

open class GDAXBidAsk {
    
    open let type: GDAXBidAskType
    open let price: Double
    open let size: Double
    
    public init(type: GDAXBidAskType, price: Double, size: Double) {
        self.type = type
        self.price = price
        self.size = size
    }
}
