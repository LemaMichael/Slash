//
//  GDAXSocketClientLogger.swift
//  GDAXSocketSwift
//
//  Created by Hani Shabsigh on 11/1/17.
//  Copyright © 2017 Hani Shabsigh. All rights reserved.
//

import Foundation

public protocol GDAXSocketClientLogger: class {
    func logGDAXSocketDidConnect(socket: GDAXSocketClient)
    func logGDAXSocketDidDisconnect(socket: GDAXSocketClient, error: Error?)
    func logGDAXSocketDidReceiveMessage(socket: GDAXSocketClient, text: String)
    func logGDAXSocketResponseParsingFailure(socket: GDAXSocketClient, message: String)
    func logGDAXSocketAuthenticationBuilderError(socket: GDAXSocketClient, message: String)
    func logGDAXSocketGeneralError(socket: GDAXSocketClient, message: String)
}

public class GDAXSocketClientDefaultLogger: GDAXSocketClientLogger {
    
    public init() {
        
    }
    
    public func logGDAXSocketDidConnect(socket: GDAXSocketClient) {
        print("--")
        print("-- GDAXSocketClient CONNECT \(socket.baseURLString ?? "")")
    }
    
    public func logGDAXSocketDidDisconnect(socket: GDAXSocketClient, error: Error?) {
        print("--")
        print("-- GDAXSocketClient DISCONNECT \(socket.baseURLString ?? "")")
    }
    
    public func logGDAXSocketDidReceiveMessage(socket: GDAXSocketClient, text: String) {
        print("--")
        guard let data = text.data(using: .utf8) else { return }
        guard let json = data.json else { return }
        let type = json["type"] as? String ?? ""
        print("-- GDAXSocketClient MESSAGE TYPE:\(type.uppercased())")
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted]) else { return }
        guard let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) else { return }
        print(jsonString)
    }
    
    public func logGDAXSocketResponseParsingFailure(socket: GDAXSocketClient, message: String) {
        print("----GDAXSocketClient Parsing Error----")
        print("\n")
        print("Failure to parse json key: \(message)")
        print("\n")
        print("----GDAXSocketClient Parsing Error----")
    }
    
    public func logGDAXSocketAuthenticationBuilderError(socket: GDAXSocketClient, message: String) {
        print("----GDAXSocketClient Authentication Error----")
        print("\n")
        print(message)
        print("\n")
        print("----GDAXSocketClient Authentication Error----")
    }
    
    public func logGDAXSocketGeneralError(socket: GDAXSocketClient, message: String) {
        print("----GDAXSocketClient General Error----")
        print("\n")
        print(message)
        print("\n")
        print("----GDAXSocketClient General Error----")
    }
}
