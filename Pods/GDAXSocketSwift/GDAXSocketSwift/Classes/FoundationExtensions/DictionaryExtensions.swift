//
//  DictionaryExtensions.swift
//  GDAXSocketSwift
//
//  Created by Hani Shabsigh on 10/27/17.
//  Copyright © 2017 Hani Shabsigh. All rights reserved.
//

import Foundation

internal extension Dictionary {
    
    internal var jsonData: Data? {
        do {
            return try JSONSerialization.data(withJSONObject: self, options: [])
        } catch _ { }
        return nil
    }
}
