//
//  GDAXSocketClient.swift
//  GDAXSocketSwift
//
//  Created by Hani Shabsigh on 10/26/17.
//  Copyright © 2017 Hani Shabsigh. All rights reserved.
//

import Foundation

@objc public class GDAXSocketClient: NSObject {
    
    public static let baseAPIURLString = "wss://ws-feed.gdax.com"
    public static let baseSandboxAPIURLString = "wss://ws-feed-public.sandbox.gdax.com"
    
    internal let apiKey: String?
    internal let secret64: String?
    internal let passphrase: String?
    
    public weak var delegate: GDAXSocketClientDelegate?
    public var webSocket: GDAXWebSocketClient? {
        didSet(oldSocket) {
            webSocket?.delegate = self
            baseURLString = webSocket?.baseURLString
        }
    }
    public var logger: GDAXSocketClientLogger?
    
    private(set) var baseURLString: String?
    private(set) var currentSubscriptions: [GDAXSubscription]?
    
    public var isConnected: Bool {
        guard let connected = self.webSocket?.isConnected else {
            return false
        }
        return connected
    }
    
    public init(apiKey: String? = nil,
                secret64: String? = nil,
                passphrase: String? = nil) {
        self.apiKey = apiKey
        self.secret64 = secret64
        self.passphrase = passphrase
    }
    
    public func connect() {
        webSocket?.connect()
    }
    
    public func disconnect() {
        webSocket?.disconnect()
    }
    
    public func subscribe(channels: [GDAXChannel], productIds: [GDAXProductId]) {
        let subscribe = GDAXSubscribe(channels: channels, productIds: productIds)
        authenticateAndWrite(json: subscribe.asJSON())
    }
    
    public func unsubscribe(channels: [GDAXChannel], productIds: [GDAXProductId]) {
        let unsubscribe = GDAXUnsubscribe(channels: channels, productIds: productIds)
        authenticateAndWrite(json: unsubscribe.asJSON())
    }
    
    private func authenticate(json: [String: Any]) -> [String: Any] {
        var json = json
        do {
            try GDAXSocketAuthenticator.authenticate(jsonObject: &json, apiKey: apiKey, secret64: secret64, passphrase: passphrase)
        } catch GDAXError.authenticationBuilderError(let message) {
            logger?.logGDAXSocketAuthenticationBuilderError(socket: self, message: message)
        } catch { }
        return json
    }
    
    private func authenticateAndWrite(json: [String: Any]) {
        let authenticatedJson = authenticate(json: json)
        self.write(json: authenticatedJson)
    }
    
    private func write(json: [String: Any]) {
        guard let jsonData = json.jsonData else { return }
        guard let jsonString = String(data: jsonData, encoding: .utf8) else { return }
        webSocket?.write(string: jsonString)
    }
    
    private func processIncomingMessage(text: String) {
        guard let json = convertTextToJson(text: text) else {
            self.logger?.logGDAXSocketGeneralError(socket: self, message: "Failed to create JSON object from incoming WebSocket message.")
            return
        }
        do {
            try self.notifyDelegatesOfIncomingJSONMessage(json: json)
        } catch GDAXError.responseParsingFailure(let message) {
            self.logger?.logGDAXSocketResponseParsingFailure(socket: self, message: message)
        } catch { }
    }
    
    private func convertTextToJson(text:String) -> [String: Any]? {
        guard let data = text.data(using: .utf8) else {
            return nil
        }
        guard let json = data.json else {
            return nil
        }
        return json
    }
    
    private func notifyDelegatesOfIncomingJSONMessage(json: [String: Any]) throws {
        guard let type = json["type"] as? String else { return }
        guard let gdaxType = GDAXType(rawValue: type) else { return }
        switch gdaxType {
        case .error:
            let error = try GDAXErrorMessage(json: json)
            self.delegate?.gdaxSocketClientOnErrorMessage?(socket: self, error: error)
            break
        case .subscriptions:
            let subscriptions = try GDAXSubscriptions(json: json)
            self.currentSubscriptions = subscriptions.channels
            self.delegate?.gdaxSocketClientOnSubscriptions?(socket: self, subscriptions: subscriptions)
            break
        case .heartbeat:
            let heartbeat = try GDAXHeartbeat(json: json)
            self.delegate?.gdaxSocketClientOnHeartbeat?(socket: self, heartbeat: heartbeat)
            break
        case .ticker:
            let ticker = try GDAXTicker(json: json)
            self.delegate?.gdaxSocketClientOnTicker?(socket: self, ticker: ticker)
            break
        case .snapshot:
            let snapshot = try GDAXSnapshot(json: json)
            self.delegate?.gdaxSocketClientOnSnapshot?(socket: self, snapshot: snapshot)
            break
        case .update:
            let update = try GDAXUpdate(json: json)
            self.delegate?.gdaxSocketClientOnUpdate?(socket: self, update: update)
            break
        case .received:
            let received = try GDAXReceived(json: json)
            self.delegate?.gdaxSocketClientOnReceived?(socket: self, received: received)
            break
        case .open:
            let open = try GDAXOpen(json: json)
            self.delegate?.gdaxSocketClientOnOpen?(socket: self, open: open)
            break
        case .done:
            let done = try GDAXDone(json: json)
            self.delegate?.gdaxSocketClientOnDone?(socket: self, done: done)
            break
        case .match:
            let match = try GDAXMatch(json: json)
            self.delegate?.gdaxSocketClientOnMatch?(socket: self, match: match)
            break
        case .change:
            let change = try GDAXChange(json: json)
            self.delegate?.gdaxSocketClientOnChange?(socket: self, change: change)
            break
        case .marginProfileUpdate:
            let marginProfileUpdate = try GDAXMarginProfileUpdate(json: json)
            self.delegate?.gdaxSocketClientOnMarginProfileUpdate?(socket: self, marginProfileUpdate: marginProfileUpdate)
            break
        case .activate:
            let activate = try GDAXActivate(json: json)
            self.delegate?.gdaxSocketClientOnActivate?(socket: self, activate: activate)
            break
        case .unknown:
            fallthrough
        default:
            print("GDAXSocketClient received unknown json message with format \(json)")
            break
        }
    }
}

extension GDAXSocketClient: GDAXWebSocketClientDelegate {
    
    public func websocketDidConnect(socket: GDAXWebSocketClient) {
        self.logger?.logGDAXSocketDidConnect(socket: self)
        self.delegate?.gdaxSocketDidConnect?(socket: self)
    }
    
    public func websocketDidDisconnect(socket: GDAXWebSocketClient, error: Error?) {
        self.logger?.logGDAXSocketDidDisconnect(socket: self, error: error)
        self.currentSubscriptions = nil
        self.delegate?.gdaxSocketDidDisconnect?(socket: self, error: error)
    }
    
    public func websocketDidReceiveMessage(socket: GDAXWebSocketClient, text: String) {
        self.logger?.logGDAXSocketDidReceiveMessage(socket: self, text: text)
        self.processIncomingMessage(text: text)
    }
}
