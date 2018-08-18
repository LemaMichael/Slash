//
//  JSONConvertible.swift
//  GDAXSocketSwift
//
//  Created by Hani Shabsigh on 10/27/17.
//  Copyright © 2017 Hani Shabsigh. All rights reserved.
//

public protocol JSONConvertible {
    
    func asJSON() -> [String: Any]
}
