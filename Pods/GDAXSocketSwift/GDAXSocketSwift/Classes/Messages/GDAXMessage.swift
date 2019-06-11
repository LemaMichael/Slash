//
//  GDAXMessage.swift
//  GDAXSocketSwift
//
//  Created by Hani Shabsigh on 10/29/17.
//  Copyright © 2017 Hani Shabsigh. All rights reserved.
//

import Foundation

open class GDAXMessage: NSObject, JSONInitializable {
    
    public let type: GDAXType

    public required init(json: [String: Any]) throws {

        guard let type = GDAXType(rawValue: json["type"] as? String ?? "") else {
            throw GDAXError.responseParsingFailure("type")
        }
        
        self.type = type
    }
}
