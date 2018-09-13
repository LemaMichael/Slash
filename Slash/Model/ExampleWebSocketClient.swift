//
//  ExampleWebSocketClient.swift
//  GDAXSocketSwift_Example
//
//  Created by Hani Shabsigh on 11/2/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import GDAXSocketSwift
import Starscream

public class ExampleWebSocketClient: GDAXWebSocketClient {
    
    fileprivate let socket: WebSocket
    
    public let baseURLString: String
    
    public required init(url: URL) {
        baseURLString = url.absoluteString
        socket = WebSocket(url: url)
        socket.delegate = self
    }
    
    public weak var delegate: GDAXWebSocketClientDelegate?
    
    public func connect() {
        socket.connect()
    }
    
    public func disconnect() {
        socket.disconnect()
    }
    
    public var isConnected: Bool {
        return self.socket.isConnected
    }
    
    public func write(string: String) {
        socket.write(string: string)
    }
}

extension ExampleWebSocketClient: WebSocketDelegate {
    
    public func websocketDidConnect(socket: WebSocketClient) {
        self.delegate?.websocketDidConnect(socket: self)
    }
    
    public func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        self.delegate?.websocketDidDisconnect(socket: self, error: error)
    }
    
    public func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        self.delegate?.websocketDidReceiveMessage(socket: self, text: text)
    }
    
    public func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
}
