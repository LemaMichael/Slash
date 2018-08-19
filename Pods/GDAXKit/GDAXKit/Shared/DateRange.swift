//
//  DateRange.swift
//  GDAXKit
//
//  Created by Steve on 1/15/18.
//  Copyright © 2018 Steve Wight. All rights reserved.
//

import UIKit

public enum DateRange {
    case oneDay
    case threeDays
    case fiveDays
    case oneWeek
    case oneMonth
    case oneQuarter
    case oneYear
    case threeYears
    case fiveYears
    
    public func dates()->(start:Date,end:Date) {
        return (start(),Date())
    }
    
    public func start()->Date {
        switch self {
        case .oneDay:
            return dateBack(unit: .day, amount: 1)
        case .threeDays:
            return dateBack(unit: .day, amount: 3)
        case .fiveDays:
            return dateBack(unit: .day, amount: 5)
        case .oneWeek:
            return dateBack(unit: .day, amount: 7)
        case .oneMonth:
            return dateBack(unit: .month, amount: 1)
        case .oneQuarter:
            return dateBack(unit: .month, amount: 3)
        case .oneYear:
            return dateBack(unit: .year, amount: 1)
        case .threeYears:
            return dateBack(unit: .year, amount: 3)
        case .fiveYears:
            return dateBack(unit: .year, amount: 5)
        }
    }
    
    private func dateBack(unit:Calendar.Component,amount:Int)->Date {
        return Calendar.current.date(
            byAdding: unit,
            value: -amount,
            to: Date()
        )!
    }
    
}
