//
//  UserDefaultsExtension.swift
//  Slash
//
//  Created by Michael Lema on 8/22/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import UIKit

extension UserDefaults {
    enum UserDefaultKeys: String {
        case Username, BTCBalance, ETHBalance, LTCBalance, BCHBalance, ETCBalance, ZRXBalance
        case BTCPrice, ETHPrice, LTCPrice, BCHPrice, ETCPrice, ZRXPrice
        case BTCPercent, ETHPercent, LTCPercent, BCHPercent, ETCPercent, ZRXPercent
        case isLoggedIn, isFirstLaunch
        case user
    }
    
    func setUser(value: Data) {
        set(value, forKey: UserDefaultKeys.user.rawValue)
        synchronize()
    }
    func getUser() -> User {
        guard let userData = UserDefaults.standard.data(forKey: UserDefaultKeys.user.rawValue) else {
            return User(name: "User", btcBalance: 0, ethBalance: 0, ltcBalance: 0, bchBalance: 0, etcBlance: 0, zrxBalance: 0)
        }
        let user = try! JSONDecoder().decode(User.self, from: userData)
        return user
    }
    
    //: Anything else to add?
    func setUsername(value: String) {
        set(value, forKey: UserDefaultKeys.Username.rawValue)
        synchronize()
    }
    func getUsername() -> String {
        guard let validName = string(forKey: UserDefaultKeys.Username.rawValue) else { return "User" }
        return validName
    }
    //: Number of coins user has
    func setBTCBalance(value: Double) {
        set(value, forKey: UserDefaultKeys.BTCBalance.rawValue)
        synchronize()
    }
    func getBTCBalance() -> Double {
        return double(forKey: UserDefaultKeys.BTCBalance.rawValue)
    }
    func setETHBalance(value: Double) {
        set(value, forKey: UserDefaultKeys.ETHBalance.rawValue)
        synchronize()
    }
    func getETHBalance() -> Double {
        return double(forKey: UserDefaultKeys.ETHBalance.rawValue)
    }
    func setLTCBalance(value: Double) {
        set(value, forKey: UserDefaultKeys.LTCBalance.rawValue)
        synchronize()
    }
    func getLTCBalance() -> Double {
        return double(forKey: UserDefaultKeys.LTCBalance.rawValue)
    }
    func setBCHBalance(value: Double) {
        set(value, forKey: UserDefaultKeys.BCHBalance.rawValue)
        synchronize()
    }
    func getBCHBalance() -> Double {
        return double(forKey: UserDefaultKeys.BCHBalance.rawValue)
    }
    func setETCBalance(value: Double) {
        set(value, forKey: UserDefaultKeys.ETCBalance.rawValue)
        synchronize()
    }
    func getETCBalance() -> Double {
        return double(forKey: UserDefaultKeys.ETCBalance.rawValue)
    }
    func setZRXBalance(value: Double) {
        set(value, forKey: UserDefaultKeys.ZRXBalance.rawValue)
        synchronize()
    }
    func getZRXBalance() -> Double {
        return double(forKey: UserDefaultKeys.ZRXBalance.rawValue)
    }
    
    //: We need the value of each coin
    func setBTCPrice(value: Double) {
        set(value, forKey: UserDefaultKeys.BTCPrice.rawValue)
        synchronize()
    }
    func getBTCPrice() -> Double {
        return double(forKey: UserDefaultKeys.BTCPrice.rawValue)
    }
    func setETHPrice(value: Double) {
        set(value, forKey: UserDefaultKeys.ETHPrice.rawValue)
        synchronize()
    }
    func getETHPrice() -> Double {
        return double(forKey: UserDefaultKeys.ETHPrice.rawValue)
    }
    func setLTCPrice(value: Double) {
        set(value, forKey: UserDefaultKeys.LTCPrice.rawValue)
        synchronize()
    }
    func getLTCPrice() -> Double {
        return double(forKey: UserDefaultKeys.LTCPrice.rawValue)
    }
    func setBCHPrice(value: Double) {
        set(value, forKey: UserDefaultKeys.BCHPrice.rawValue)
        synchronize()
    }
    func getBCHPrice() -> Double {
        return double(forKey: UserDefaultKeys.BCHPrice.rawValue)
    }
    func setETCPrice(value: Double) {
        set(value, forKey: UserDefaultKeys.ETCPrice.rawValue)
        synchronize()
    }
    func getETCPrice() -> Double {
        return double(forKey: UserDefaultKeys.ETCPrice.rawValue)
    }
    
    func setZRXPrice(value: Double) {
        set(value, forKey: UserDefaultKeys.ZRXPrice.rawValue)
        synchronize()
    }
    func getZRXPrice() -> Double {
        return double(forKey: UserDefaultKeys.ZRXPrice.rawValue)
    }
    
    //: Get the total price, coin amount * current price
    func getTotalPrice(coin: String) -> Double {
        switch coin {
        case "Bitcoin":
            return getBTCBalance() * getBTCPrice()
        case "Ethereum":
            return getETHBalance() * getETHPrice()
        case "Litecoin":
            return getLTCBalance() * getLTCPrice()
        case "Bitcoin Cash":
            return getBCHBalance() * getBCHPrice()
        case "Ethereum Classic":
            return getETCBalance() * getETCPrice()
        case "0x":
            return getZRXBalance() * getZRXPrice()
        default:
            return 0
        }
    }

    func setCoinPrice(name: String, value: Double) {
        switch name {
        case "Bitcoin":
            set(value, forKey: UserDefaultKeys.BTCBalance.rawValue)
            synchronize()
        case "Ethereum":
            set(value, forKey: UserDefaultKeys.ETHBalance.rawValue)
            synchronize()
        case "Litecoin":
            set(value, forKey: UserDefaultKeys.LTCBalance.rawValue)
            synchronize()
        case "Bitcoin Cash":
            set(value, forKey: UserDefaultKeys.BCHBalance.rawValue)
            synchronize()
        case "Ethereum Classic":
            set(value, forKey: UserDefaultKeys.ETCBalance.rawValue)
            synchronize()
        case "0x":
            set(value, forKey: UserDefaultKeys.ZRXBalance.rawValue)
            synchronize()
        default:
            return
        }
    }
    
    //:TODO- Find the last date & time it was updated.
    func setGainLoss(percent: Double, coin: String) {
        switch coin {
        case "Bitcoin":
            set(percent, forKey: UserDefaultKeys.BTCPercent.rawValue)
            synchronize()
        case "Ethereum":
            set(percent, forKey: UserDefaultKeys.ETHPercent.rawValue)
            synchronize()
        case "Litecoin":
            set(percent, forKey: UserDefaultKeys.LTCPercent.rawValue)
            synchronize()
        case "Bitcoin Cash":
            set(percent, forKey: UserDefaultKeys.BCHPercent.rawValue)
            synchronize()
        case "Ethereum Classic":
            set(percent, forKey: UserDefaultKeys.ETCPercent.rawValue)
            synchronize()
        case "0x":
            set(percent, forKey: UserDefaultKeys.ZRXPercent.rawValue)
            synchronize()
        default:
            return
        }
    }
    func getGainLoss(coin: String) -> Double {
        switch coin {
        case "Bitcoin":
           return double(forKey: UserDefaultKeys.BTCPercent.rawValue)
        case "Ethereum":
            return double(forKey: UserDefaultKeys.ETHPercent.rawValue)
        case "Litecoin":
            return double(forKey: UserDefaultKeys.LTCPercent.rawValue)
        case "Bitcoin Cash":
            return double(forKey: UserDefaultKeys.BCHPercent.rawValue)
        case "Ethereum Classic":
            return double(forKey: UserDefaultKeys.ETCPercent.rawValue)
        case "0x":
            return double(forKey: UserDefaultKeys.ZRXPercent.rawValue)
        default:
            return 0.0
        }
    }
    
    //: Determine if the user has logged in before
    func setIsLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultKeys.isLoggedIn.rawValue)
        synchronize()
    }
    func isLoggedIn() -> Bool {
        return bool(forKey: UserDefaultKeys.isLoggedIn.rawValue)
    }
    
    //: TODO: Do something with this
    func setIsFirstLaunch(value: Bool) {
        set(value, forKey: UserDefaultKeys.isFirstLaunch.rawValue)
    }
    func isFirstLaunch() -> Bool {
        return bool(forKey: UserDefaultKeys.isFirstLaunch.rawValue)
    }
    
}
