//
//  GDAXUpdateChange.swift
//  GDAXSocketSwift
//
//  Created by Hani Shabsigh on 10/29/17.
//  Copyright © 2017 Hani Shabsigh. All rights reserved.
//

import Foundation

open class GDAXUpdateChange {
    
    open let side: GDAXSide
    open let price: Double
    open let size: Double
    
    public init(side: GDAXSide, price: Double, size: Double) {
        self.side = side
        self.price = price
        self.size = size
    }
}
