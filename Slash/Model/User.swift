//
//  User.swift
//  Slash
//
//  Created by Michael Lema on 8/22/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import Foundation
import UIKit


class User {
    
    var name: String!
    //: Coins available
    var bitcoinBalance: Double!
    var ethereumBalance: Double!
    var litecoinBalance: Double!
    var bitcoinCashBalance: Double!
    var ethereumClassicBalance: Double!
    
    init() {
        name = UserDefaults.standard.getUsername()
        bitcoinBalance = UserDefaults.standard.getBTCBalance()
        ethereumBalance = UserDefaults.standard.getETHBalance()
        litecoinBalance = UserDefaults.standard.getLTCBalance()
        bitcoinCashBalance = UserDefaults.standard.getBCHBalance()
        ethereumClassicBalance = UserDefaults.standard.getETCBalance()
    }
    
    init(name: String, btcBalance: Double, ethBalance: Double, ltcBalance: Double, bchBalance: Double, etcBlance: Double) {
        
        self.name = (name.isEmpty) ? "User" : name
        self.bitcoinBalance = btcBalance
        self.ethereumBalance = ethBalance
        self.litecoinBalance = ltcBalance
        self.bitcoinCashBalance = bchBalance
        self.ethereumClassicBalance = etcBlance
        
        UserDefaults.standard.setUsername(value: self.name)
        UserDefaults.standard.setBTCBalance(value: bitcoinBalance)
        UserDefaults.standard.setETHBalance(value: ethereumBalance)
        UserDefaults.standard.setLTCBalance(value: litecoinBalance)
        UserDefaults.standard.setBCHBalance(value: bitcoinCashBalance)
        UserDefaults.standard.setETCBalance(value: ethereumClassicBalance)
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
        default:
            return 0.00
        }
    }
    
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
        default:
            return 0.00
        }
    }
    
    
    func balance() -> Double {
        //: 1- We need to get the total balance of all the coins
        let bitcoinBalance = UserDefaults.standard.getBTCBalance()
        let ethereumBalance = UserDefaults.standard.getETHBalance()
        let litecoinBalance = UserDefaults.standard.getLTCBalance()
        let bitcoinCashBalance = UserDefaults.standard.getBCHBalance()
        let ethereumClassicBalance = UserDefaults.standard.getETCBalance()
        
        //: 2- We need to get the current price for all the coins
        let bitcoinPrice = UserDefaults.standard.getBTCPrice()
        let ethereumPrice = UserDefaults.standard.getETHPrice()
        let litecoinPrice  = UserDefaults.standard.getLTCPrice()
        let bitcoinCashPrice  = UserDefaults.standard.getBCHPrice()
        let ethereumClassicPrice  = UserDefaults.standard.getETCPrice()
        
        //: 3-Multiply
        let totalBalance = (bitcoinPrice * bitcoinBalance) + (ethereumPrice * ethereumBalance) + (litecoinPrice * litecoinBalance) + (bitcoinCashPrice * bitcoinCashBalance) + (ethereumClassicPrice * ethereumClassicBalance)
        
        return totalBalance
    }
    
    func amountOfCoins() -> Double {
        let bitcoinBalance = UserDefaults.standard.getBTCBalance()
        let ethereumBalance = UserDefaults.standard.getETHBalance()
        let litecoinBalance = UserDefaults.standard.getLTCBalance()
        let bitcoinCashBalance = UserDefaults.standard.getBCHBalance()
        let ethereumClassicBalance = UserDefaults.standard.getETCBalance()
        
        return bitcoinBalance + ethereumBalance + litecoinBalance + bitcoinCashBalance + ethereumClassicBalance
    }
    
    
    func portfolioPercentage(coinName: String) -> Double {
      
        //: 1-Get current balance and price of the coin
        let coinBalance = getCoinBalance(coinName: coinName)
        let coinPrice = getCoinPrice(coinName: coinName)
        
        let holdingValue = coinBalance * coinPrice
        
        //: 2-Get percentage
        if (amountOfCoins() == 0) {
            return 0.00
        } else {
            let percentage = (holdingValue / balance())
            return percentage
        }
    }
    
}
