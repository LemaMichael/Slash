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
        case Username, BTCBalance, ETHBalance, LTCBalance, BCHBalance, ETCBalance
        case BTCPrice, ETHPrice, LTCPrice, BCHPrice, ETCPrice
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
    func setBTCBalance(value: Double)  {
        set(value, forKey: UserDefaultKeys.BTCBalance.rawValue)
        synchronize()
    }
    func getBTCBalance() -> Double {
        return double(forKey: UserDefaultKeys.BTCBalance.rawValue)
    }
    func setETHBalance(value: Double)  {
        set(value, forKey: UserDefaultKeys.ETHBalance.rawValue)
        synchronize()
    }
    func getETHBalance() -> Double {
        return double(forKey: UserDefaultKeys.ETHBalance.rawValue)
    }
    func setLTCBalance(value: Double)  {
        set(value, forKey: UserDefaultKeys.LTCBalance.rawValue)
        synchronize()
    }
    func getLTCBalance() -> Double {
        return double(forKey: UserDefaultKeys.LTCBalance.rawValue)
    }
    func setBCHBalance(value: Double)  {
        set(value, forKey: UserDefaultKeys.BCHBalance.rawValue)
        synchronize()
    }
    func getBCHBalance() -> Double {
        return double(forKey: UserDefaultKeys.BCHBalance.rawValue)
    }
    func setETCBalance(value: Double)  {
        set(value, forKey: UserDefaultKeys.ETCBalance.rawValue)
        synchronize()
    }
    func getETCBalance() -> Double {
        return double(forKey: UserDefaultKeys.ETCBalance.rawValue)
    }
    
    //: We need the value of each coin
    func setBTCPrice(value: Double)  {
        set(value, forKey: UserDefaultKeys.BTCPrice.rawValue)
        synchronize()
    }
    func getBTCPrice() -> Double {
        return double(forKey: UserDefaultKeys.BTCPrice.rawValue)
    }
    func setETHPrice(value: Double)  {
        set(value, forKey: UserDefaultKeys.ETHPrice.rawValue)
        synchronize()
    }
    func getETHPrice() -> Double {
        return double(forKey: UserDefaultKeys.ETHPrice.rawValue)
    }
    func setLTCPrice(value: Double)  {
        set(value, forKey: UserDefaultKeys.LTCPrice.rawValue)
        synchronize()
    }
    func getLTCPrice() -> Double {
        return double(forKey: UserDefaultKeys.LTCPrice.rawValue)
    }
    func setBCHPrice(value: Double)  {
        set(value, forKey: UserDefaultKeys.BCHPrice.rawValue)
        synchronize()
    }
    func getBCHPrice() -> Double {
        return double(forKey: UserDefaultKeys.BCHPrice.rawValue)
    }
    func setETCPrice(value: Double)  {
        set(value, forKey: UserDefaultKeys.ETCPrice.rawValue)
        synchronize()
    }
    func getETCPrice() -> Double {
        return double(forKey: UserDefaultKeys.ETCPrice.rawValue)
    }
    
    //: Find the last date & time it was updated.
    
}

