//
//  SocketManager.swift
//  c01ns
//
//  Created by Steve on 1/6/18.
//  Copyright © 2018 Steve Wight. All rights reserved.
//

import UIKit
import Starscream

enum SocketStreamType: String {
    case ticker = "ticker"
    case heartbeat = "heartbeat"
    case none = "none"
}

class SocketManager {
    let request = SocketRequest()
    var streamType:SocketStreamType = .none
    let socket:WebSocket = WebSocket(
        url: URL(string:"wss://ws-feed.gdax.com")!
    )
    
    public func connect(_ client:SocketClient) {
        socket.delegate = client
        socket.connect()
    }
    
    public func sendRequest(products:[Product]) {
        request.setStream(
            streamType: streamType,
            products: products
        )
        let requestData = request.encodedData()
        let dataString = String(
            data:requestData,
            encoding:.utf8
        )!
        socket.write(string: dataString)
    }

}


