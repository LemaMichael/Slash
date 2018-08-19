//
//  SocketFactory.swift
//  c01ns
//
//  Created by Steve on 1/5/18.
//  Copyright © 2018 Steve Wight. All rights reserved.
//

import UIKit

class SocketFactory: NSObject {

    public class func decodeSocketMsg(_ msg:String)->Decodable {
        let decoder = JSONDecoder()
        var socketMsg = SocketMsg()
        let data = msg.data(using: .utf8)
        do {
            socketMsg = try decoder.decode(
                SocketMsg.self,
                from:data!
            )
        } catch {
            print("issue decoding the SocketMsg: \(error.localizedDescription)")
        }
        let socketObj = buildSocketObject(
            data!, socketMsg.type
        )
        return socketObj
    }
    
    private class func buildSocketObject(_ data:Data,_ type:SocketMsgType)->Decodable {
        var socketObject:Decodable?
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom({ (decoder)-> Date in
            return decoder.iso8601Custom()
        })
        do {
            switch type {
            case .heartbeat:
                socketObject = try decoder.decode(
                    Heartbeat.self,
                    from: data
                )
            case .ticker:
                socketObject = try decoder.decode(
                    SocketTicker.self,
                    from: data
                )
            case .none, .snapshot, .update, .subscribtions:
                socketObject = try decoder.decode(
                    SocketError.self,
                    from: data
                )
            }
        } catch {
            print("Issue building socket object")
            print(error)
        }
        return socketObject!
    }
    
}
