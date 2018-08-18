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
import GDAXSocketSwift

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
    
    struct url {
        static let btcUSD = "BTC-USD"
        static let ethUSD = "ETH-USD"
        static let ltcUSD = "LTC-USD"
        static let bchUSD = "BCH-USD"
        static let etcUSD = "ETC-USD"
    }
    let url = "https://api.pro.coinbase.com/products"
    var socketClient: GDAXSocketClient = GDAXSocketClient()
    
    let priceFormatter: NumberFormatter = NumberFormatter()
    let timeFormatter: DateFormatter = DateFormatter()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !socketClient.isConnected {
            socketClient.connect()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        socketClient.delegate = self
        socketClient.webSocket = ExampleWebSocketClient(url: URL(string: GDAXSocketClient.baseAPIURLString)!)
        socketClient.logger = GDAXSocketClientDefaultLogger()
        
        priceFormatter.numberStyle = .decimal
        priceFormatter.maximumFractionDigits = 2
        priceFormatter.minimumFractionDigits = 2
        
        timeFormatter.dateStyle = .short
        timeFormatter.timeStyle = .medium
        
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


extension BaseViewController: GDAXSocketClientDelegate {
    func gdaxSocketDidConnect(socket: GDAXSocketClient) {
        socket.subscribe(channels:[.ticker], productIds:[.BTCUSD, .ETHUSD, .LTCUSD, .BCHUSD, .ETCUSD])
    }
    
    func gdaxSocketDidDisconnect(socket: GDAXSocketClient, error: Error?) {
        print("Error!")
    }
    
    func gdaxSocketClientOnErrorMessage(socket: GDAXSocketClient, error: GDAXErrorMessage) {
        print(error.message)
    }
    
    func gdaxSocketClientOnTicker(socket: GDAXSocketClient, ticker: GDAXTicker) {
        let formattedPrice = priceFormatter.string(from: ticker.price as NSNumber) ?? "0.0000"
        print("Price = " + formattedPrice)
        print(ticker.productId.rawValue)
    }
}
