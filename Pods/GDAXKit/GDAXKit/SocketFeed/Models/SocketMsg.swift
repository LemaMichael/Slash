//
//  SocketMsg.swift
//  c01ns
//
//  Created by Steve on 1/5/18.
//  Copyright © 2018 Steve Wight. All rights reserved.
//

import UIKit

enum SocketMsgType: String, Decodable {
    case ticker = "ticker"
    case heartbeat = "heartbeat"
    case snapshot = "snapshot" // for level2 channel
    case update = "12update" // for level2 channel
    case subscribtions = "subscriptions"
    case none = "none"
}

public class SocketMsg:Decodable {
    let type:SocketMsgType
    enum CodingKeys:String, CodingKey { case type }
    init() { type = .none }
}
