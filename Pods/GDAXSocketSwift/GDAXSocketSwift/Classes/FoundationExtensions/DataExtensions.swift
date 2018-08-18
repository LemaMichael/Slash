//
//  DataExtensions.swift
//  GDAXSocketSwift
//
//  Created by Hani Shabsigh on 10/27/17.
//  Copyright © 2017 Hani Shabsigh. All rights reserved.
//

import Foundation

internal extension Data {
    
    internal var json: [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any]
        } catch _ { }
        return nil
    }
    
    internal var jsonArray: [Any]? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: []) as? [Any]
        } catch _ { }
        return nil
    }
}
