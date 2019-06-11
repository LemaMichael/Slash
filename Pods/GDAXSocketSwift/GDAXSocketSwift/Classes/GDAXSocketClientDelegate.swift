//
//  GDAXSocketClientDelegate.swift
//  GDAXSocketSwift
//
//  Created by Hani Shabsigh on 11/5/17.
//  Copyright © 2017 Hani Shabsigh. All rights reserved.
//

import Foundation

@objc public protocol GDAXSocketClientDelegate: class {
    @objc optional func gdaxSocketDidConnect(socket: GDAXSocketClient)
    @objc optional func gdaxSocketDidDisconnect(socket: GDAXSocketClient, error: Error?)
    
    @objc optional func gdaxSocketClientOnErrorMessage(socket: GDAXSocketClient, error: GDAXErrorMessage)
    
    @objc optional func gdaxSocketClientOnSubscriptions(socket: GDAXSocketClient, subscriptions: GDAXSubscriptions)
    
    @objc optional func gdaxSocketClientOnHeartbeat(socket: GDAXSocketClient, heartbeat: GDAXHeartbeat)
    
    @objc optional func gdaxSocketClientOnTicker(socket: GDAXSocketClient, ticker: GDAXTicker)
    
    @objc optional func gdaxSocketClientOnSnapshot(socket: GDAXSocketClient, snapshot: GDAXSnapshot)
    @objc optional func gdaxSocketClientOnUpdate(socket: GDAXSocketClient, update: GDAXUpdate)
    
    @objc optional func gdaxSocketClientOnReceived(socket: GDAXSocketClient, received: GDAXReceived)
    @objc optional func gdaxSocketClientOnOpen(socket: GDAXSocketClient, open: GDAXOpen)
    @objc optional func gdaxSocketClientOnDone(socket: GDAXSocketClient, done: GDAXDone)
    @objc optional func gdaxSocketClientOnMatch(socket: GDAXSocketClient, match: GDAXMatch)
    @objc optional func gdaxSocketClientOnChange(socket: GDAXSocketClient, change: GDAXChange)
    @objc optional func gdaxSocketClientOnMarginProfileUpdate(socket: GDAXSocketClient, marginProfileUpdate: GDAXMarginProfileUpdate)
    @objc optional func gdaxSocketClientOnActivate(socket: GDAXSocketClient, activate: GDAXActivate)
}
