//
//  Params.swift
//  GDAXKit
//
//  Created by Steve on 1/16/18.
//  Copyright © 2018 Steve Wight. All rights reserved.
//

import UIKit

enum Params {
    case historic(range:DateRange,granularity:Granularity)
    case historicDates(start:Date,end:Date,granularity:Granularity)
    
    public func build()->[String:String] {
        switch self {
        case let .historic(range,granularity):
            return buildRange(range, granularity:granularity)
        case let .historicDates(start,end,granularity):
            return buildDates(start: start, end: end, granularity: granularity)
        }
    }
    
    private func buildRange(_ range:DateRange, granularity:Granularity)->[String:String] {
        let dates = range.dates()
        return buildDates(
            start: dates.start,
            end: dates.end,
            granularity: granularity
        )
    }
    
    private func buildDates(start:Date, end:Date, granularity:Granularity)->[String:String] {
        var params = [String:String]()
        params["start"] = start.iso8601
        params["end"] = end.iso8601
        params["granularity"] = granularity.rawValue
        return params
    }
}
