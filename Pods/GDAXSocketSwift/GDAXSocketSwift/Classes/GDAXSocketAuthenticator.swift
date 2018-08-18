//
//  GDAXSocketAuthenticator.swift
//  GDAXSocketSwift
//
//  Created by Hani Shabsigh on 10/28/17.
//  Copyright © 2017 Hani Shabsigh. All rights reserved.
//

import CryptoSwift

internal class GDAXSocketAuthenticator {
    
    internal class func authenticate(jsonObject: inout [String:Any], apiKey: String?, secret64: String?, passphrase: String?) throws {
        guard let apiKey = apiKey, let secret64 = secret64, let passphrase = passphrase else {
            throw GDAXError.authenticationBuilderError("GDAX API key, secret and passphrase are not defined")
        }
        
        let timestamp = Int64(Date().timeIntervalSince1970)
        let method = "GET"
        let relativeURL = "/users/self/verify"
        let signature = try generateSignature(secret64: secret64, timestamp: timestamp, method: method, relativeURL: relativeURL)
        
        jsonObject["signature"] = signature
        jsonObject["key"] = apiKey
        jsonObject["passphrase"] = passphrase
        jsonObject["timestamp"] = timestamp
    }
    
    private class func generateSignature(secret64: String, timestamp: Int64, method: String, relativeURL: String) throws -> String {
        let preHash = "\(timestamp)\(method.uppercased())\(relativeURL)"
        
        guard let secret = Data(base64Encoded: secret64) else {
            throw GDAXError.authenticationBuilderError("Failed to base64 decode secret")
        }
        
        guard let preHashData = preHash.data(using: .utf8) else {
            throw GDAXError.authenticationBuilderError("Failed to convert preHash into data")
        }
        
        guard let hmac = try HMAC(key: secret.bytes, variant: .sha256).authenticate(preHashData.bytes).toBase64() else {
            throw GDAXError.authenticationBuilderError("Failed to generate HMAC from preHash")
        }
        
        return hmac
    }
}
