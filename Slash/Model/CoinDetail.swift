//
//  CoinDetail.swift
//  Slash
//
//  Created by Michael Lema on 8/18/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import Foundation


class CoinDetail: NSObject {
    //: https://api.pro.coinbase.com/currencies
    var id, name: String! //BTC, Bitcoin
    
    //: Get 24 hour stats, GET /products/<product-id>/stats
    var currentPrice, open, high, low, volume, thirtyDayVolume: String!
    let zero = 0.0
    
    func difference () -> Double {
        guard let price = self.currentPrice else { return zero }
        guard let doublePrice = Double(price) else { return zero }
        guard let open = self.open else { return zero }
        guard let openDouble = Double(open) else { return zero }
        let diff = doublePrice - openDouble
        return diff
    }
    func percent() -> Double {
        guard let price = self.currentPrice else { return zero }
        guard let doublePrice = Double(price) else { return zero }
        guard let open = self.open else { return zero }
        guard let openDouble = Double(open) else { return zero }
        
        let percent = ((1/(openDouble / doublePrice)) - 1) * 100
        return percent
    }
    
}

/* Ticker Example
 {
 "trade_id": 4729088,
 "price": "333.99",
 "size": "0.193",
 "bid": "333.98",
 "ask": "333.99",
 "volume": "5957.11914015",
 "time": "2015-11-14T20:46:03.511254Z"
 }
 */

struct Ticker: Decodable {
    let tradeID: Int
    let price, size, bid, ask: String
    let volume, time: String
    
    enum CodingKeys: String, CodingKey {
        case tradeID = "trade_id"
        case price, size, bid, ask, volume, time
    }
}



/* Currencies example
 {
 "id":"BTC",
 "name":"Bitcoin",
 "min_size":"0.00000001",
 "status":"online",
 "message":null
 },
 */
typealias Currencies = [Currency]
struct Currency: Decodable {
    var id, name, minSize: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case minSize = "min_size"
    }
}

/*Stats example
 {
 "open":"14.26000000",
 "high":"14.94000000",
 "low":"12.69000000",
 "volume":"1231648.45616216",
 "last":"13.11000000",
 "volume_30day":"4358880.80496818"
 }
 */
struct Stats: Codable {
    let statsOpen, high, low, volume: String
    let last, volume30Day: String
    
    enum CodingKeys: String, CodingKey {
        case statsOpen = "open"
        case high, low, volume, last
        case volume30Day = "volume_30day"
    }
}


/* Products example
 {
 "id":"ETC-EUR",
 "base_currency":"ETC",
 "quote_currency":"EUR",
 "base_min_size":"0.1",
 "base_max_size":"5000",
 "quote_increment":"0.01",
 "display_name":"ETC/EUR",
 "status":"online",
 "margin_enabled":false,
 "status_message":"",
 "min_market_funds":"10",
 "max_market_funds":"100000",
 "post_only":false,
 "limit_only":false,
 "cancel_only":false
 },
 */
typealias Products = [Product]
struct Product: Decodable {
    let id, baseCurrency, quoteCurrency, baseMinSize: String
    let baseMaxSize, quoteIncrement, displayName: String
    let status: Status
    let marginEnabled: Bool
    let statusMessage: String?
    let minMarketFunds, maxMarketFunds: String
    let postOnly, limitOnly, cancelOnly: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case baseCurrency = "base_currency"
        case quoteCurrency = "quote_currency"
        case baseMinSize = "base_min_size"
        case baseMaxSize = "base_max_size"
        case quoteIncrement = "quote_increment"
        case displayName = "display_name"
        case status
        case marginEnabled = "margin_enabled"
        case statusMessage = "status_message"
        case minMarketFunds = "min_market_funds"
        case maxMarketFunds = "max_market_funds"
        case postOnly = "post_only"
        case limitOnly = "limit_only"
        case cancelOnly = "cancel_only"
    }
}
enum Status: String, Codable {
    case online = "online"
}
