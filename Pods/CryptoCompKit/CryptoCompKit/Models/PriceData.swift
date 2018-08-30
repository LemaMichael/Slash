//
//  PriceData.swift
//  Vault
//
//  Created by Steve on 5/9/18.
//  Copyright © 2018 Steve Wight. All rights reserved.
//

import UIKit

public class PriceData:Codable {
    public var type = ""
    public var market = ""
    public var fromSymbol = ""
    public var toSymbol = ""
    public var flags = ""
    public var price = 0.0
    public var lastUpdate = 0
    public var lastVolume = 0.0
    public var lastVolumeTo = 0.0
    public var lastTradeID = ""
    public var volumeDay = 0.0
    public var volumeDayTo = 0.0
    public var volume24Hour = 0.0
    public var volume24HourTo = 0.0
    public var openDay = 0.0
    public var highDay = 0.0
    public var lowDay = 0.0
    public var open24Hour = 0.0
    public var high24Hour = 0.0
    public var low24Hour = 0.0
    public var lastMarket = ""
    public var change24Hour = 0.0
    public var changePercent24Hour = 0.0
    public var changeDay = 0.0
    public var changePercentDay = 0.0
    public var supply = 0.0
    public var marketCap = 0.0
    public var totalVolume24Hour = 0.0
    public var totalVolume24HourTo = 0.0
    
    enum CodingKeys: String, CodingKey {
        case type = "TYPE"
        case market = "MARKET"
        case fromSymbol = "FROMSYMBOL"
        case toSymbol = "TOSYMBOL"
        case flags = "FLAGS"
        case price = "PRICE"
        case lastUpdate = "LASTUPDATE"
        case lastVolume = "LASTVOLUME"
        case lastVolumeTo = "LASTVOLUMETO"
        case lastTradeID = "LASTTRADEID"
        case volumeDay = "VOLUMEDAY"
        case volumeDayTo = "VOLUMEDAYTO"
        case volume24Hour = "VOLUME24HOUR"
        case volume24HourTo = "VOLUME24HOURTO"
        case openDay = "OPENDAY"
        case highDay = "HIGHDAY"
        case lowDay = "LOWDAY"
        case open24Hour = "OPEN24HOUR"
        case high24Hour = "HIGH24HOUR"
        case low24Hour = "LOW24HOUR"
        case lastMarket = "LASTMARKET"
        case change24Hour = "CHANGE24HOUR"
        case changePercent24Hour = "CHANGEPCT24HOUR"
        case changeDay = "CHANGEDAY"
        case changePercentDay = "CHANGEPCTDAY"
        case supply = "SUPPLY"
        case marketCap = "MKTCAP"
        case totalVolume24Hour = "TOTALVOLUME24H"
        case totalVolume24HourTo = "TOTALVOLUME24HTO"
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decode(String.self, forKey: .type)
        market = try values.decode(String.self, forKey: .market)
        fromSymbol = try values.decode(String.self, forKey: .fromSymbol)
        toSymbol = try values.decode(String.self, forKey: .toSymbol)
        flags = try values.decode(String.self, forKey: .flags)
        price = try values.decode(Double.self, forKey: .price)
        do {
            lastUpdate = try values.decode(Int.self, forKey: .lastUpdate)
            lastVolume = try values.decode(Double.self, forKey: .lastVolume)
            lastVolumeTo = try values.decode(Double.self, forKey: .lastVolumeTo)
            lastTradeID = try values.decode(String.self, forKey: .lastTradeID)
        } catch { }
        do {
            volumeDay = try values.decode(Double.self, forKey: .volumeDay)
            volumeDayTo = try values.decode(Double.self, forKey: .volumeDayTo)
            volume24Hour = try values.decode(Double.self, forKey: .volume24Hour)
            volume24HourTo = try values.decode(Double.self, forKey: .volume24HourTo)
        } catch { }
        do {
            openDay = try values.decode(Double.self, forKey: .openDay)
            highDay = try values.decode(Double.self, forKey: .highDay)
            lowDay = try values.decode(Double.self, forKey: .lowDay)
            open24Hour = try values.decode(Double.self, forKey: .open24Hour)
            high24Hour = try values.decode(Double.self, forKey: .high24Hour)
            low24Hour = try values.decode(Double.self, forKey: .low24Hour)
            lastMarket = try values.decode(String.self, forKey: .lastMarket)
        } catch { }
        do {
            change24Hour = try values.decode(Double.self, forKey: .change24Hour)
            changePercent24Hour = try values.decode(Double.self, forKey: .changePercent24Hour)
            changeDay = try values.decode(Double.self, forKey: .changeDay)
            changePercentDay = try values.decode(Double.self, forKey: .changePercentDay)
            supply = try values.decode(Double.self, forKey: .supply)
            marketCap = try values.decode(Double.self, forKey: .marketCap)
            totalVolume24Hour = try values.decode(Double.self, forKey: .totalVolume24Hour)
            totalVolume24HourTo = try values.decode(Double.self, forKey: .totalVolume24HourTo)
        } catch { }
    }
}
