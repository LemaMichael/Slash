//
//  CoinDetail.swift
//  Slash
//
//  Created by Michael Lema on 8/18/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import Foundation
import Charts

class CoinDetail: NSObject {
    //: https://api.pro.coinbase.com/currencies
    var id, name: String! //BTC, Bitcoin
    
    //: Get 24 hour stats, GET /products/<product-id>/stats
    var currentPrice, open, high, low, volume, thirtyDayVolume: String!
    
    var chartDataEntry = [ChartDataEntry]()
    
    let zero = 0.0
    
    func difference() -> Double {
        guard let price = self.currentPrice else { return zero }
        let validPrice = price.split(separator: ",").joined(separator: "")  //: Needed to correctly calc percent for Bitcoin
        guard let doublePrice = Double(validPrice) else { return zero }
        guard let open = self.open else { return zero }
        guard let openDouble = Double(open) else { return zero }
        let diff = doublePrice - openDouble
        return diff
    }
    
    func difference(to value: Double) -> Double {
        guard let openVal = self.open else { return zero }
        let validOpenPrice = openVal.split(separator: ",").joined(separator: "")
        guard let openPrice = Double(validOpenPrice) else { return zero } //: Properly convert to Double
        let diff = value - openPrice
        return diff
    }
    
    func percent() -> Double {
        guard let price = self.currentPrice else { return zero }
        let validPrice = price.split(separator: ",").joined(separator: "")  //: Needed to correctly calc percent for Bitcoin
        guard let doublePrice = Double(validPrice) else { return zero }
        guard let open = self.open else { return zero }
        guard let openDouble = Double(open) else { return zero }
        
        let percent = ((1/(openDouble / doublePrice)) - 1) * 100
        return percent
    }
    
    func percent(to value: Double) -> Double {
        guard let openVal = self.open else { return zero }
        let validOpenPrice = openVal.split(separator: ",").joined(separator: "")
        guard let openPrice = Double(validOpenPrice) else { return zero } //: Properly convert to Double
        
        let percent = ((1/(openPrice / value)) - 1) * 100
        return percent
    }
    
    //: Get the current price in type Double
    func validCurrentPrice() -> Double {
        guard let price = self.currentPrice else { return zero }
        let validPrice = price.split(separator: ",").joined(separator: "")
        guard let doublePrice = Double(validPrice) else { return zero }
        return doublePrice
    }
    
    func imageName() -> String {
        //:AWESOME
        let start = name.startIndex
        let end = name.index(start, offsetBy: 3)
        let range = start..<end
        return String(name[range])
    }
    
    func officialName() -> String {
        let start = name.startIndex
        let end = name.index(start, offsetBy: 3)
        let range = start..<end
        
        let id = String(name[range])
        switch id {
        case "BTC":
            return "Bitcoin"
        case "ETH":
            return "Ethereum"
        case "LTC":
            return "Litecoin"
        case "BCH":
            return "Bitcoin Cash"
        case "ETC":
            return "Ethereum Classic"
        case "ZRX":
            return "0x"
        default:
            return "..."
        }
    }
    
    func description(coinName: String) -> String {
        switch coinName {
        case "Bitcoin":
            return "The world’s first cryptocurrency, bitcoin is stored and exchanged securely on the internet through a digital ledger known as a blockchain. Bitcoins are divisible into smaller units known as satoshis — each satoshi is worth 0.00000001 bitcoin. \n- Coinbase"
        case "Ethereum":
            return "Ethereum is both a cryptocurrency and a decentralized computing platform. Developers can use Ethereum to create decentralized applications and issue new assets, known as tokens. \n- Coinbase"
        case "Litecoin":
            return "Litecoin is a cryptocurrency that uses a faster payment confirmation schedule and a different cryptographic algorithm than Bitcoin. \n- Coinbase"
        case "Bitcoin Cash":
            return "Bitcoin Cash is a fork of Bitcoin that seeks to add more transaction capacity to the network in order to be useful for everyday transactions. \n- Coinbase"
        case "Ethereum Classic":
            return "Ethereum Classic is a cryptocurrency with a special focus on immutability, popularly expressed as “code is law. \n- Coinbase"
        default:
            return "..."
        }
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
/*
struct Stats: Codable {
    let statsOpen, high, low, volume: String
    let last, volume30Day: String
    
    enum CodingKeys: String, CodingKey {
        case statsOpen = "open"
        case high, low, volume, last
        case volume30Day = "volume_30day"
    }
}
 */

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
