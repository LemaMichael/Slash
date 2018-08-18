//
//  GDAXWebSocketClientProtocol.swift
//  GDAXSocketSwift
//
//  Created by Hani Shabsigh on 10/31/17.
//  Copyright © 2017 Hani Shabsigh. All rights reserved.
//

import Foundation

public protocol GDAXWebSocketClientDelegate: class {
    func websocketDidConnect(socket: GDAXWebSocketClient)
    func websocketDidDisconnect(socket: GDAXWebSocketClient, error: Error?)
    func websocketDidReceiveMessage(socket: GDAXWebSocketClient, text: String)
}

public protocol GDAXWebSocketClient: class {
    
    var baseURLString: String { get }
    
    weak var delegate: GDAXWebSocketClientDelegate? { get set}
    
    func connect()
    func disconnect()
    
    var isConnected: Bool { get }
    
    func write(string: String)
}
