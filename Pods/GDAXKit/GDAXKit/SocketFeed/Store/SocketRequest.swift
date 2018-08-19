//
//  SocketRequest.swift
//  c01ns
//
//  Created by Steve on 1/4/18.
//  Copyright © 2018 Steve Wight. All rights reserved.
//

import UIKit

class SocketRequest:Encodable {
    var type:String
    var productIDs:[String]
    var channels:[SocketChannel]
    
    enum CodingKeys: String, CodingKey {
        case type, channels
        case productIDs = "product_ids"
    }
    
    init() {
        type = "subscribe"
        productIDs = []
        channels = []
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(productIDs, forKey: .productIDs)
        try container.encode(channels, forKey: .channels)
    }
    
    public func encodedData()->Data {
        let encoder = JSONEncoder()
        var data = Data()
        do {
            data = try encoder.encode(self)
        } catch {
            print("Issue encoding the request")
        }
        return data
    }
    
    public func setStream(streamType:SocketStreamType, products:[Product]) {
        switch streamType {
        case .ticker:
            ticker(products)
        case .heartbeat:
            heartbeat(products)
        case .none:
            print("SocketStreamType not set yet")
        }
    }
    
    private func ticker(_ products:[Product]) {
        subscribe(.ticker, products)
    }
    
    private func heartbeat(_ products:[Product]) {
        subscribe(.heartbeat, products)
    }
    
    private func level2(_ products:[Product]) {
        subscribe(.level2, products)
    }
    
    private func subscribe(_ channelType:SocketChannelType,_ products:[Product]) {
        type = "subscribe"
        productIDs = products.map { $0.id }
        channels = [buildChannel(channelType)]
    }
    
    private func buildChannel(_ channelType:SocketChannelType)->SocketChannel {
        return SocketChannel(type:channelType, productIDs:productIDs)
    }
    
}
