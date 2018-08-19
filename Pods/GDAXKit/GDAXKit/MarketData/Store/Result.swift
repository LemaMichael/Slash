//
//  Result.swift
//  GDAXKit
//
//  Created by Steve on 1/23/18.
//  Copyright © 2018 Steve Wight. All rights reserved.
//

import UIKit

public enum Result<Value> {
    case success(Value)
    case failure(Error)
    
    public func value()->Any {
        switch self {
        case .success(let value):
            return value
        case .failure(_):
            return []
        }
    }
}
