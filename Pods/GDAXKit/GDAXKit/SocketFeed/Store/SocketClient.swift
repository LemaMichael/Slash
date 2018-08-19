//
//  SocketClient.swift
//  c01ns
//
//  Created by Steve on 1/5/18.
//  Copyright © 2018 Steve Wight. All rights reserved.
//

import UIKit
import Starscream

public protocol SocketClientDelegate {
    func socketClientConnected()
    func socketClientDisconnected()
    func socketClientTick(_ tick:SocketTicker)
    func socketClientHeartbeat(_ heartbeat:Heartbeat)
    func socketClientError(_ error:SocketError)
}

public class SocketClient {

    let delegate:SocketClientDelegate!
    let socketManager = SocketManager()
    var products = [Product]()
    
    public init(delegate:SocketClientDelegate) {
        self.delegate = delegate
    }
    
    public func startTickerStream(products:[Product]) {
        self.products = products
        socketManager.streamType = .ticker
        socketManager.connect(self)
    }
    
    public func startHeartbeatStream(products:[Product]) {
        self.products = products
        socketManager.streamType = .heartbeat
        socketManager.connect(self)
    }
    
}

extension SocketClient: WebSocketDelegate {
    
    public func websocketDidConnect(socket: WebSocketClient) {
        socketManager.sendRequest(products:products)
        delegate?.socketClientConnected()
    }
    
    public func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        delegate?.socketClientDisconnected()
    }
    
    public func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        let msgObject = SocketFactory.decodeSocketMsg(text)
        if msgObject is SocketTicker {
            delegate?.socketClientTick(msgObject as! SocketTicker)
        } else if msgObject is Heartbeat {
            delegate?.socketClientHeartbeat(msgObject as! Heartbeat)
        } else if msgObject is SocketError {
            delegate?.socketClientError(msgObject as! SocketError)
        }
    }
    
    public func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("data: \(data.count)")
    }
}
