//
//  CoinHistory.swift
//  Slash
//
//  Created by Michael Lema on 9/1/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import Foundation
import UIKit
import Charts

class RequestCoinHistory {
    //: https://api.coinranking.com/v1/public/coin/:coin_id/history/:timeframe
    //: https://api.coinranking.com/v1/public/coin/1335/history/7d?base=EUR
    var chartDataEntry = [ChartDataEntry]()
    var historyData: DataClass2? = nil
    
    func requestHistory(coinID: String, timeFrame: String, base: String = "USD", finished: @escaping () -> Void) {
        guard let url = URL(string: "https://api.coinranking.com/v1/public/coin/\(coinID)/history/\(timeFrame)?base=\(base)") else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                self.chartDataEntry.removeAll()
                let decoder = JSONDecoder()
                let history = try decoder.decode(CoinHistory.self, from: data)
                self.historyData = history.data

                //: Change is percentage change over given time frame
                //print("!!! \(history.status) Change: \(history.data.change), History Count: \(history.data.history.count)\n\n\n\n")
                for history in history.data.history {
                    //print("!!! \(history.price), \(history.price.value()), \(history.timestamp)")
                    let xVal = Double(history.timestamp/1000)
                    let yVal = Double(history.price.value()) ?? 0
                    self.chartDataEntry.append(ChartDataEntry(x: xVal, y: yVal))
                }
                finished()
                //print("!!! The highest price here is \(self.getHighPrice())")
                //print("!!! The lowest price here is \(self.getLowPrice())")
                //print("!!! The Change %  here is \(self.getPercentChange())")
            } catch let error as NSError {
                print("!!! error \(error.localizedDescription)")
            }
            }.resume()
    }
    
    func getHighPrice() -> Double {
        guard let historyData = historyData else { return 0 }
        let historyPrices = historyData.history.map({NSString(string: $0.price.value()).doubleValue})
        return historyPrices.max() ?? 0
    }
    
    func getLowPrice() -> Double {
        guard let historyData = historyData else { return 0 }
        let historyPrices = historyData.history.map({NSString(string: $0.price.value()).doubleValue})
        return historyPrices.min() ?? 0
    }
    func getPercentChange() -> Double {
        //: Percentage of change over the given time frame
        guard let historyData = historyData else { return 0 }
        return historyData.change
    }
}

struct CoinHistory: Codable {
    let status: String
    let data: DataClass2
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case data = "data"
    }
}

struct DataClass2: Codable {
    let change: Double
    let history: [History]
    
    enum CodingKeys: String, CodingKey {
        case change = "change"
        case history = "history"
    }
}

struct History: Codable {
    let price: Price
    let timestamp: Int
    
    enum CodingKeys: String, CodingKey {
        case price = "price"
        case timestamp = "timestamp"
    }
}

enum Price: Codable {
    case double(Double)
    case string(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Double.self) {
            self = .double(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Price.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Price"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .double(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
    
    func value() -> String {
        switch self {
        case .double(let num):
            return "\(num)"
        case .string(let num):
            return num
        }
    }
}
