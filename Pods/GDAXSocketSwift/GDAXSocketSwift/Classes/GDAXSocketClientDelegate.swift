//
//  GDAXSocketClientDelegate.swift
//  GDAXSocketSwift
//
//  Created by Hani Shabsigh on 11/5/17.
//  Copyright © 2017 Hani Shabsigh. All rights reserved.
//

import Foundation

public protocol GDAXSocketClientDelegate: class {
    func gdaxSocketDidConnect(socket: GDAXSocketClient)
    func gdaxSocketDidDisconnect(socket: GDAXSocketClient, error: Error?)
    
    func gdaxSocketClientOnErrorMessage(socket: GDAXSocketClient, error: GDAXErrorMessage)
    
    func gdaxSocketClientOnSubscriptions(socket: GDAXSocketClient, subscriptions: GDAXSubscriptions)
    
    func gdaxSocketClientOnHeartbeat(socket: GDAXSocketClient, heartbeat: GDAXHeartbeat)
    
    func gdaxSocketClientOnTicker(socket: GDAXSocketClient, ticker: GDAXTicker)
    
    func gdaxSocketClientOnSnapshot(socket: GDAXSocketClient, snapshot: GDAXSnapshot)
    func gdaxSocketClientOnUpdate(socket: GDAXSocketClient, update: GDAXUpdate)
    
    func gdaxSocketClientOnReceived(socket: GDAXSocketClient, received: GDAXReceived)
    func gdaxSocketClientOnOpen(socket: GDAXSocketClient, open: GDAXOpen)
    func gdaxSocketClientOnDone(socket: GDAXSocketClient, done: GDAXDone)
    func gdaxSocketClientOnMatch(socket: GDAXSocketClient, match: GDAXMatch)
    func gdaxSocketClientOnChange(socket: GDAXSocketClient, change: GDAXChange)
    func gdaxSocketClientOnMarginProfileUpdate(socket: GDAXSocketClient, marginProfileUpdate: GDAXMarginProfileUpdate)
    func gdaxSocketClientOnActivate(socket: GDAXSocketClient, activate: GDAXActivate)
}

extension GDAXSocketClientDelegate {
    
    public func gdaxSocketDidConnect(socket: GDAXSocketClient) {}
    
    public func gdaxSocketDidDisconnect(socket: GDAXSocketClient, error: Error?) {}
    
    public func gdaxSocketClientOnErrorMessage(socket: GDAXSocketClient, error: GDAXErrorMessage) {}
    
    public func gdaxSocketClientOnSubscriptions(socket: GDAXSocketClient, subscriptions: GDAXSubscriptions) {}
    
    public func gdaxSocketClientOnHeartbeat(socket: GDAXSocketClient, heartbeat: GDAXHeartbeat) {}
    
    public func gdaxSocketClientOnTicker(socket: GDAXSocketClient, ticker: GDAXTicker) {}
    
    public func gdaxSocketClientOnSnapshot(socket: GDAXSocketClient, snapshot: GDAXSnapshot) {}
    
    public func gdaxSocketClientOnUpdate(socket: GDAXSocketClient, update: GDAXUpdate) {}
    
    public func gdaxSocketClientOnReceived(socket: GDAXSocketClient, received: GDAXReceived) {}
    
    public func gdaxSocketClientOnOpen(socket: GDAXSocketClient, open: GDAXOpen) {}
    
    public func gdaxSocketClientOnDone(socket: GDAXSocketClient, done: GDAXDone) {}
    
    public func gdaxSocketClientOnMatch(socket: GDAXSocketClient, match: GDAXMatch) {}
    
    public func gdaxSocketClientOnChange(socket: GDAXSocketClient, change: GDAXChange) {}
    
    public func gdaxSocketClientOnMarginProfileUpdate(socket: GDAXSocketClient, marginProfileUpdate: GDAXMarginProfileUpdate) {}
    
    public func gdaxSocketClientOnActivate(socket: GDAXSocketClient, activate: GDAXActivate) {}
}
