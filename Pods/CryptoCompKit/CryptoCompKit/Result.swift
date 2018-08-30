//
//  Result.swift
//  Vault
//
//  Created by Steve on 5/9/18.
//  Copyright © 2018 Steve Wight. All rights reserved.
//

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
