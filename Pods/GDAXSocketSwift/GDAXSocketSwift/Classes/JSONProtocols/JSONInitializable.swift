//
//  JSONInitializable.swift
//  GDAXSocketSwift
//
//  Created by Hani Shabsigh on 10/27/17.
//  Copyright © 2017 Hani Shabsigh. All rights reserved.
//

internal protocol JSONInitializable {
    
    init(json: [String: Any]) throws
}
