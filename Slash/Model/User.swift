//
//  User.swift
//  Slash
//
//  Created by Michael Lema on 8/22/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import Foundation
import UIKit

class User: Codable {
    
    var name: String
    //: Coins available
    var bitcoinBalance: Double
    var ethereumBalance: Double
    var litecoinBalance: Double
    var bitcoinCashBalance: Double
    var ethereumClassicBalance: Double
    var zrxBlanace: Double
    
    init(name: String, btcBalance: Double, ethBalance: Double, ltcBalance: Double, bchBalance: Double, etcBlance: Double, zrxBalance: Double) {
        self.name = (name.isEmpty) ? "User" : name.trimmingCharacters(in: .whitespaces)
        self.bitcoinBalance = btcBalance
        self.ethereumBalance = ethBalance
        self.litecoinBalance = ltcBalance
        self.bitcoinCashBalance = bchBalance
        self.ethereumClassicBalance = etcBlance
        self.zrxBlanace = zrxBalance
        
        UserDefaults.standard.setUsername(value: self.name)
        UserDefaults.standard.setBTCBalance(value: bitcoinBalance)
        UserDefaults.standard.setETHBalance(value: ethereumBalance)
        UserDefaults.standard.setLTCBalance(value: litecoinBalance)
        UserDefaults.standard.setBCHBalance(value: bitcoinCashBalance)
        UserDefaults.standard.setETCBalance(value: ethereumClassicBalance)
        UserDefaults.standard.setZRXBalance(value: self.zrxBlanace)
        
        //: Must save user        
        let userData = try! JSONEncoder().encode(self)
        UserDefaults.standard.setUser(value: userData)
    }
    
    func getName() -> String {
       return UserDefaults.standard.getUsername()
    }
    
    func getCoinBalance(coinName: String) -> Double {
        switch coinName {
        case "Bitcoin":
            return UserDefaults.standard.getBTCBalance()
        case "Ethereum":
            return UserDefaults.standard.getETHBalance()
        case "Litecoin":
            return UserDefaults.standard.getLTCBalance()
        case "Bitcoin Cash":
            return UserDefaults.standard.getBCHBalance()
        case "Ethereum Classic":
            return UserDefaults.standard.getETCBalance()
        case "0x":
            return UserDefaults.standard.getZRXBalance()
        default:
            return 0.00
        }
    }
    
    /// Returns the current coin price
    /// - parameter coinName:: String
    func getCoinPrice(coinName: String) -> Double {
        switch coinName {
        case "Bitcoin":
            return UserDefaults.standard.getBTCPrice()
        case "Ethereum":
            return UserDefaults.standard.getETHPrice()
        case "Litecoin":
            return UserDefaults.standard.getLTCPrice()
        case "Bitcoin Cash":
            return UserDefaults.standard.getBCHPrice()
        case "Ethereum Classic":
            return UserDefaults.standard.getETCPrice()
        case "0x":
            return UserDefaults.standard.getZRXPrice()
        default:
            return 0.00
        }
    }
    
    /// Returns the total cost of a coin. (Current coin price * coin balance)
    /// - parameter coinName:: String
    func getTotalCost(coinName: String) -> Double {
        let coinBalance = getCoinBalance(coinName: coinName)
        let coinPrice = getCoinPrice(coinName: coinName)
        
        let holdingValue = coinBalance * coinPrice
        return holdingValue
    }
    
    /// Total Portfolio Balance
    func balance() -> Double {
        //: 1- We need to get the total balance of all the coins
        let bitcoinBalance = UserDefaults.standard.getBTCBalance()
        let ethereumBalance = UserDefaults.standard.getETHBalance()
        let litecoinBalance = UserDefaults.standard.getLTCBalance()
        let bitcoinCashBalance = UserDefaults.standard.getBCHBalance()
        let ethereumClassicBalance = UserDefaults.standard.getETCBalance()
        let zrxBalance = UserDefaults.standard.getZRXBalance()
        
        //: 2- We need to get the current price for all the coins
        let bitcoinPrice = UserDefaults.standard.getBTCPrice()
        let ethereumPrice = UserDefaults.standard.getETHPrice()
        let litecoinPrice  = UserDefaults.standard.getLTCPrice()
        let bitcoinCashPrice  = UserDefaults.standard.getBCHPrice()
        let ethereumClassicPrice  = UserDefaults.standard.getETCPrice()
        let zrxPrice = UserDefaults.standard.getZRXPrice()
        
        //: 3-Multiply
        let totalBalance = (bitcoinPrice * bitcoinBalance) + (ethereumPrice * ethereumBalance) + (litecoinPrice * litecoinBalance) + (bitcoinCashPrice * bitcoinCashBalance) + (ethereumClassicPrice * ethereumClassicBalance) + (zrxPrice * zrxBalance)
        
        return totalBalance
    }
    
    func amountOfCoins() -> Double {
        let bitcoinBalance = UserDefaults.standard.getBTCBalance()
        let ethereumBalance = UserDefaults.standard.getETHBalance()
        let litecoinBalance = UserDefaults.standard.getLTCBalance()
        let bitcoinCashBalance = UserDefaults.standard.getBCHBalance()
        let ethereumClassicBalance = UserDefaults.standard.getETCBalance()
        let zrxBalance = UserDefaults.standard.getZRXBalance()
        
        return bitcoinBalance + ethereumBalance + litecoinBalance + bitcoinCashBalance + ethereumClassicBalance + zrxBalance
    }
    
    /// This returns an array of coin names that have a balance > 0.
    func getAllHoldings() -> [String] {
        var supportedCoins = ["Bitcoin", "Ethereum", "Litecoin", "Bitcoin Cash", "Ethereum Classic", "0x"]
        
        for (index, coin) in supportedCoins.enumerated().reversed() {
            if getCoinBalance(coinName: coin) == 0 {
                supportedCoins.remove(at: index)
            }
        }
        return supportedCoins
    }
    
    func portfolioPercentage(coinName: String) -> Double {
      
        //: 1-Get current balance and price of the coin
        let coinBalance = getCoinBalance(coinName: coinName)
        let coinPrice = getCoinPrice(coinName: coinName)
        
        let holdingValue = coinBalance * coinPrice
        
        //: 2-Get percentage
        if amountOfCoins() == 0 {
            return 0.00
        } else {
            let percentage = (holdingValue / balance())
            return percentage
        }
    }
    
}
