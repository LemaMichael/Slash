//
//  HomeViewController.swift
//  Slash
//
//  Created by Michael Lema on 8/16/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import GDAXSocketSwift
import GDAXKit
import Charts

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var coins: [CoinDetail] = [CoinDetail]() {
        didSet {
            self.collectionView.reloadData()
            if coins.count >= 5 {
                getHistoricData()
            }
        }
    }
    var socketClient: GDAXSocketClient = GDAXSocketClient()
    
    let priceFormatter: NumberFormatter = NumberFormatter()
    let timeFormatter: DateFormatter = DateFormatter()
    
    
    // Initialize a client
    let client = MarketClient()
    
    //var values = [ChartDataEntry]()
    //var historyArray = [[ChartDataEntry]]()
    //var coinID = ["BTC-USD", "ETH-USD", "LTC-USD", "BCH-USD", "ETC-USD"]
    
    static let coinCellId = "cellId"
    
    var interval: TimeInterval!
    var timer: Timer!
    var firstPrice = ""
    var secondPrice = ""
    var thirdPrice = ""
    var fourthPrice = ""
    var fifthPrice = ""
    
    var pairs = [Pair]()
    
    var firstPairID: String!
    var secondPairID: String!
    var thirdPairID: String!
    var fourthPairID: String!
    var fifthPairID: String!
    
    var chosenPairs: [Pair] = []
    var reachability: Reachability?
    var fontPosistive: NSMutableAttributedString!
    var fontNegative: NSMutableAttributedString!
    var font:  [String : NSObject]!
    var useColouredSymbols = true
    
    let defaults = Foundation.UserDefaults.standard
    let pairsURL = "https://api.pro.coinbase.com/"
    let green = UIColor.init(red: 22/256, green: 206/255, blue: 0/256, alpha: 1)
    let red = UIColor.init(red: 255/256, green: 73/255, blue: 0/256, alpha: 1)
    let white = UIColor.init(red: 255, green: 255, blue: 255, alpha: 1)
    
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        //layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CoinCell.self, forCellWithReuseIdentifier: HomeViewController.coinCellId)
        return collectionView
    }()
    
    var settingsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "settings").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func settingsTapped() {
        //: Button animation
        UIView.animate(withDuration: 0.2, animations: {
            self.settingsButton.transform = CGAffineTransform(scaleX: 0.92, y: 0.96)
        }) { _ in
            UIView.animate(withDuration: 0.2, animations: {
                self.settingsButton.transform = CGAffineTransform.identity
            })
        }
        //: FIXME: BRing up a tableViewController later
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        socketClient.delegate = self
        socketClient.webSocket = ExampleWebSocketClient(url: URL(string: GDAXSocketClient.baseAPIURLString)!)
        socketClient.logger = GDAXSocketClientDefaultLogger()
        
        priceFormatter.numberStyle = .decimal
        priceFormatter.maximumFractionDigits = 2
        priceFormatter.minimumFractionDigits = 2
        
        timeFormatter.dateStyle = .short
        timeFormatter.timeStyle = .medium
        
        view.backgroundColor = UIColor(red:0.35, green:0.54, blue:0.90, alpha:1.0)
        self.view.addSubview(collectionView)
        self.view.addSubview(settingsButton)
        
        settingsButton.anchor(top: view.topAnchor, bottom: nil, left: nil, right: view.rightAnchor, paddingTop: 40, paddingBottom: 0, paddingLeft: 0, paddingRight: 10, width: 25, height: 25)
        collectionView.anchor(top: nil, bottom: self.view.bottomAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingBottom: -70, paddingLeft: 0, paddingRight: 0, width: 0, height: (self.view.frame.height / 2))
        
        updateTimer()
        
        
    }
    
    func getHistoricData() {
        
        // Call one of the public endpoint methods
        client.products { products, result in
            switch result {
            case .success(_):
                // Do stuff with the provided products
                for item in products {
                    print(item.id,item.baseCurrency,item.quoteCurrency,  item.baseMinSize, item.baseMaxSize, item.quoteIncrement, item.displayName, item.status, item.marginEnabled, item.statusMessage ?? "\n")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
        //: Get historic data
        //let pid = "BTC-USD"
        print("WE HAVE \(coins.count) itemss")
        for coin in coins {
            let range = DateRange.oneDay
            let granularity = Granularity.oneHour
            client.historic(pid:coin.id, range:range, granularity:granularity) { candles, result in
                switch result {
                case .success(_):
                    //: Each candle has a time, low, high. open, close, volume
                    for item in candles {
                        print(item.time, item.open, item.close, item.high, item.low)
                        let xVal = Double(item.time.timeIntervalSince1970)
                        print(xVal)
                        let yVal = item.close
                        //: FIXME: This is not a good way check
                        if coin.chartDataEntry.count < 24 {
                            print(":\(coin.chartDataEntry.count)")
                            coin.chartDataEntry.append(ChartDataEntry(x: xVal, y: yVal))
                        }
                    }
                    print("We are now appending: pid \(coin.id)")
    
                case .failure(let error):
                    print(error.localizedDescription)
                    //: One of the reasons we are here because we are making too much requests at a time
                    print("The current pid was not added \(coin.id)")
                    self.requestAgain(coin)

                }
            }
        }
    }
    
    func requestAgain(_ coin: CoinDetail) {
      
        let deadlineTime = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            print("I am in request again")
            let range = DateRange.oneDay
            let granularity = Granularity.oneHour
            let correctIndex = self.coins.index(of: coin) //: Finds the index of coin in the array coins
            guard let index = correctIndex else {return }
            let coin = self.coins[index]
            self.client.historic(pid: coin.id, range:range, granularity:granularity) { candles, result in
                switch result {
                case .success(_):
                    //: Each candle has a time, low, high. open, close, volume
                    for item in candles {
                        print(item.time, item.open, item.close, item.high, item.low)
                        let xVal = Double(item.time.timeIntervalSince1970)
                        print(xVal)
                        let yVal = item.close
                        //: FIXME: This is not a good way check
                        if coin.chartDataEntry.count < 24 {
                            coin.chartDataEntry.append(ChartDataEntry(x: xVal, y: yVal))
                        }
                    }
                    print("Was able to add: pid \(coin.id)")
                    //: Hmmm
                   // self.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                    //: One of the reasons we are here because we are making too much requests at a time
                    print("The current pid was not added2 \(coin.id)")
                    self.requestAgain(coin)
                    
                }
            }
        })
    }
    
    
    
    
    
    
    func setup() {
        if let interval = defaults.object(forKey: UserDefaults.interval.rawValue) as? TimeInterval {
            self.interval = interval
        } else {
            self.interval = TimeInterval(5)  // Default is 5 seconds
            defaults.set(self.interval, forKey: UserDefaults.interval.rawValue)
        }
    }
    
    
    func updateTimer() {
        if timer != nil {
            if timer.isValid == true {
                timer.invalidate()
            }
        }
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: self.interval, target: self, selector: #selector(self.updateCells), userInfo: nil, repeats: true)
        }
        
    }
    
    @objc func updateCells() {
        print("updateCells")
        self.collectionView.reloadData()
    }
    
    
    func updateInterval(_ interval: TimeInterval) {
        self.interval = interval
        
        defaults.set(self.interval, forKey: UserDefaults.interval.rawValue)
        defaults.synchronize()
        
        updateTimer()
    }
    
    
    //: MARK: CollectionView methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("numberOfItemsInSection called")
        return self.coins.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewController.coinCellId, for: indexPath) as! CoinCell
        if !coins.isEmpty{
            cell.update(coins[indexPath.item])
            let result = coins[indexPath.item].chartDataEntry.reversed() as [ChartDataEntry]
            cell.setChartData(values: result)
            //: MAKE SURE TO DO THIS, or else charts will not display!
//            let result = self.values.reversed() as [ChartDataEntry]
//            cell.setChartData(values: result)
            
//            if indexPath.item < historyArray.count {
//                print("Current index is \(indexPath.item) which is \(historyArray[indexPath.item])")
//                let data = historyArray[indexPath.item]
//                let result = data.reversed() as [ChartDataEntry]
//                cell.setChartData(values: result)
//            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.width - 60), height: (self.view.frame.height / 2))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //: Adjust the cell position
        let width = self.view.frame.width
        let cellWidth = (self.view.frame.width - 60)
        let diff = (width-cellWidth) / 2
        return UIEdgeInsets(top: 0, left: diff, bottom: 0, right: diff)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !socketClient.isConnected {
            socketClient.connect()
        }
    }
    
}


extension HomeViewController: GDAXSocketClientDelegate {
    func gdaxSocketDidConnect(socket: GDAXSocketClient) {
        socket.subscribe(channels:[.ticker], productIds:[.BTCUSD, .ETHUSD, .LTCUSD, .BCHUSD, .ETCUSD])
    }
    
    func gdaxSocketDidDisconnect(socket: GDAXSocketClient, error: Error?) {
        let alertController = UIAlertController(title: "No Connection", message: "Please connect to Wifi", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func gdaxSocketClientOnErrorMessage(socket: GDAXSocketClient, error: GDAXErrorMessage) {
        print(error.message)
    }
    
    func gdaxSocketClientOnTicker(socket: GDAXSocketClient, ticker: GDAXTicker) {
        let formattedPrice = priceFormatter.string(from: ticker.price as NSNumber) ?? "0.0000"
        print("Price = " + formattedPrice)
        print(ticker.productId.rawValue)
        
        let coin = CoinDetail()
        coin.id = ticker.productId.rawValue
        coin.name = coin.id
        coin.currentPrice = formattedPrice
        coin.open = String(ticker.open24h)
        coin.high = String(ticker.high24h)
        coin.low = String(ticker.low24h)
        coin.volume = String(ticker.volume24h)
        coin.thirtyDayVolume = String(ticker.volume30d)
        
        if (coins.isEmpty  || coins.count < 5) {
            coins.append(coin)
        }
        for item in coins {
            if item.id == coin.id {
                print("Item: \(item.id) is being modified")
                item.currentPrice = formattedPrice
                coin.open = String(ticker.open24h)
                item.high = String(ticker.high24h)
                item.low = String(ticker.low24h)
                item.volume = String(ticker.volume24h)
                item.thirtyDayVolume = String(ticker.volume30d)
            }
        }
        
        
        
        //        print("Currently i have: \(coins.count) items. The items are:")
        //        for item in coins {
        //            print(item.id)
        //        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
    }
}
