//
//  GDAXType.swift
//  GDAXSocketSwift
//
//  Created by Hani Shabsigh on 10/29/17.
//  Copyright © 2017 Hani Shabsigh. All rights reserved.
//

import Foundation

public enum GDAXType: String {
    case error = "error"
    case subscribe = "subscribe"
    case unsubscribe = "unsubscribe"
    case subscriptions = "subscriptions"
    case heartbeat = "heartbeat"
    case ticker = "ticker"
    case snapshot = "snapshot"
    case update = "12update"
    case received = "received"
    case open = "open"
    case done = "done"
    case match = "match"
    case change = "change"
    case marginProfileUpdate = "margin_profile_update"
    case activate = "activate"
    case unknown = ""
}
