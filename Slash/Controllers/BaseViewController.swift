//
//  File.swift
//  Slash
//
//  Created by Michael Lema on 8/18/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import UIKit
import UIKit
import Alamofire

class BaseViewController: UIViewController {
    fileprivate let coinImage:[UIImage] = [#imageLiteral(resourceName: "BTC"),#imageLiteral(resourceName: "ETH"),#imageLiteral(resourceName: "LTC"),#imageLiteral(resourceName: "BCH"),#imageLiteral(resourceName: "ETC")]
    fileprivate let coinName = ["Bitcoin", "Ethereum", "Litecoin", "Bitcoin Cash", "Ethereum Classic"]
    fileprivate let colors: [UIColor] = [UIColor(red:0.91, green:0.73, blue:0.08, alpha:1.0),
                                         UIColor(red:0.21, green:0.27, blue:0.31, alpha:1.0),
                                         UIColor(red:0.35, green:0.42, blue:0.38, alpha:1.0),
                                         UIColor(red:0.95, green:0.47, blue:0.21, alpha:1.0),
                                         UIColor(red:0.35, green:0.55, blue:0.45, alpha:1.0)]
    //fileprivate let currencies  = ["BTC-USD", "ETH-USD", "LTC-USD", "BCH-USD", "ETC-USD"]
    fileprivate var currencies = [Currency]()
    fileprivate var stats = [Stats]()
    fileprivate var products = [Product]()
    fileprivate var productID = [String]()
    
    struct URL {
        static let btcUSD = "BTC-USD"
        static let ethUSD = "ETH-USD"
        static let ltcUSD = "LTC-USD"
        static let bchUSD = "BCH-USD"
        static let etcUSD = "ETC-USD"
    }
    let url = "https://api.pro.coinbase.com/products"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTickerConnection()
        setupStats()

    }
    
    func setupTickerConnection() {
        Alamofire.request(url + "products").responseJSON { (response) in
            switch response.result {
            case .success:
                if let json = response.data {
                    print("JSON: \(json)") // serialized json response
                    do {
                        self.products = try JSONDecoder().decode(Products.self, from: json )
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func setupStats() {
        
      
    }
    
    func setupCurrencyConnection() {
        Alamofire.request(url + "currencies").responseJSON { (response) in
            switch response.result {
            case .success:
                if let json = response.data {
                    print("JSON: \(json)") // serialized json response
                    do {
                        self.currencies = try JSONDecoder().decode(Currencies.self, from: json )
                        // print(self.currencies)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    func modifyCurriencies() {
        for var item in self.currencies {
            //:Default will return Ether as the name of the currency
            if (item.name.range(of: "Ether") != nil) {
                item.name = item.name.replacingOccurrences(of: "Ether", with: "Ethereum")
            }
            print(item.name)
            print(item.id)
        }
    }
    
}
