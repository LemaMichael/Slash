//
//  StringExtensions.swift
//  GDAXSocketSwift
//
//  Created by Hani Shabsigh on 10/27/17.
//  Copyright © 2017 Hani Shabsigh. All rights reserved.
//

import Foundation

internal extension String {
    
    internal var dateFromISO8601: Date? {
        return Formatter.iso8601.date(from: self)
    }
}
