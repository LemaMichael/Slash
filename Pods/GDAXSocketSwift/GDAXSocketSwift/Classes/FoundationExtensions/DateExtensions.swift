//
//  DateExtensions.swift
//  GDAXSocketSwift
//
//  Created by Hani Shabsigh on 10/27/17.
//  Copyright © 2017 Hani Shabsigh. All rights reserved.
//

import Foundation

internal extension Date {
    
    internal var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}
