//
//  Book.swift
//  c01ns
//
//  Created by Steve on 1/2/18.
//  Copyright © 2018 Steve Wight. All rights reserved.
//

import UIKit

enum BookLevel:Int {
    case one = 1
    case two = 2
    case three = 3
}

public class Book:Codable {
    public var sequence:Int = 0
    public var bids = [Order]()
    public var asks = [Order]()
}

public class Order:Codable {
    public var price:String = ""
    public var size:String = ""
    public var numOrders:Int = 0
    
    public required init(from decoder:Decoder) throws {
        var container = try decoder.unkeyedContainer()
        price = try container.decode(String.self)
        size = try container.decode(String.self)
        numOrders = try container.decode(Int.self)
    }
}
