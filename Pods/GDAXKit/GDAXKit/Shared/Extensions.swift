//
//  Extensions.swift
//  GDAXKit
//
//  Created by Steve on 1/16/18.
//  Copyright © 2018 Steve Wight. All rights reserved.
//

extension Formatter {
    
    public static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
    
}

internal extension Date {
    
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
    
}

extension Decoder {
    
    public func iso8601Custom()->Date {
        do {
            let container = try self.singleValueContainer()
            let dateStr = try container.decode(String.self)
            if let date = Formatter.iso8601.date(from: dateStr) {
                return date
            }
        } catch { }
        return Date()
    }
    
}
