//
//  GDAXUpdate.swift
//  GDAXSocketSwift
//
//  Created by Hani Shabsigh on 10/29/17.
//  Copyright © 2017 Hani Shabsigh. All rights reserved.
//

open class GDAXUpdate: GDAXProductMessage {
    
    public let changes: [GDAXUpdateChange]
    
    public required init(json: [String: Any]) throws {
        
        guard let changes = json["changes"] as? [[String]] else {
            throw GDAXError.responseParsingFailure("changes")
        }
        
        var changeObjects = [GDAXUpdateChange]()
        for change in changes {
            guard let side = GDAXSide(rawValue: change[0]) else {
                throw GDAXError.responseParsingFailure("change_side")
            }
            
            guard let price = Double(change[1]) else {
                throw GDAXError.responseParsingFailure("change_price")
            }
            
            guard let size = Double(change[2]) else {
                throw GDAXError.responseParsingFailure("change_size")
            }
            
            changeObjects.append(GDAXUpdateChange(side: side, price: price, size: size))
        }
        
        self.changes = changeObjects
        
        try super.init(json: json)
    }
}
