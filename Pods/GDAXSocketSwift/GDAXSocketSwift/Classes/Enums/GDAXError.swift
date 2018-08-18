//
//  GDAXError.swift
//  GDAXSocketSwift
//
//  Created by Hani Shabsigh on 10/27/17.
//  Copyright © 2017 Hani Shabsigh. All rights reserved.
//

import Foundation

public enum GDAXError: Error, LocalizedError {
    
    case authenticationBuilderError(String)
    case responseParsingFailure(String)
    
    public var errorDescription: String? {
        switch self {
        case .authenticationBuilderError(let message):
            return NSLocalizedString(message, comment: "error")
        case .responseParsingFailure(let message):
            return NSLocalizedString(message, comment: "error")
        }
    }
}
