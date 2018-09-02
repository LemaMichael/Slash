//
//  HomeViewController.swift
//  Slash
//
//  Created by Michael Lema on 8/16/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import Foundation
import UIKit
import GDAXSocketSwift
import GDAXKit
import Charts

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //: Light Green color UIColor(red:0.35, green:0.42, blue:0.38, alpha:1.0),
    fileprivate let colors: [UIColor] = [UIColor(red:1.00, green:0.60, blue:0.00, alpha:1.0),
                                         UIColor(red:0.21, green:0.27, blue:0.31, alpha:1.0),
                                         UIColor(red:0.57, green:0.57, blue:0.57, alpha:1.0),
                                         UIColor(red:0.95, green:0.47, blue:0.21, alpha:1.0),
                                         UIColor(red:0.35, green:0.55, blue:0.45, alpha:1.0)]
    var coins: [CoinDetail] = [CoinDetail]() {
        didSet {
            self.collectionView.reloadData()
            if coins.count >= 5 {
                getHistoricData()
                // FIXME: Find a better place to put this. NOTE this should scroll to the cell with the highest percentage holding
                self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
                
                //: Once we have all the coins, lets do a quick anaylsis.
                quickAnalysis()
            }
        }
    }
    var socketClient: GDAXSocketClient = GDAXSocketClient()
    
    let priceFormatter: NumberFormatter = NumberFormatter()
    let timeFormatter: DateFormatter = DateFormatter()
    
    
    // Initialize a client
    let client = MarketClient()
    
    static let coinCellId = "cellId"
    var currentUser = UserDefaults.standard.getUser()
    
    var timer: Timer!

    
    var fontPosistive: NSMutableAttributedString!
    var fontNegative: NSMutableAttributedString!
    var font:  [String : NSObject]!
    var useColouredSymbols = true
    
    let defaults = Foundation.UserDefaults.standard
    let pairsURL = "https://api.pro.coinbase.com/"
    let green = UIColor.init(red: 22/256, green: 206/255, blue: 0/256, alpha: 1)
    let red = UIColor.init(red: 255/256, green: 73/255, blue: 0/256, alpha: 1)
    let white = UIColor.init(red: 255, green: 255, blue: 255, alpha: 1)
    
    
    lazy var accountBalanceLabel: UILabel = {
        let label = UILabel()
        let formattedPrice = priceFormatter.string(from: currentUser.balance() as NSNumber) ?? "0.00"
        label.text = "$" + formattedPrice //: FIXME: This shouldn't only be for US Dollar
        label.textColor = .white
        label.font = UIFont(name: "Avenir-Heavy", size: 30)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var accountDescription: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.text = "Hello \(currentUser.getName()),\n"
        label.font = UIFont(name: "Avenir-Book", size: 15)
        label.textColor = .white
        return label
    }()
    
    let todaysDateLabel: UILabel = {
        let label = UILabel()
        let date = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        let currentDate = formatter.string(from: date)
        let text = "TODAY : " + currentDate
        label.text = text.uppercased()
        label.font = UIFont(name: "Avenir-Heavy", size: 13)
        label.textColor = .white
        return label
    }()
    
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
    
    func quickAnalysis() {
        print("quick analysis: \(currentUser.bitcoinBalance, currentUser.ethereumBalance, currentUser.litecoinBalance, currentUser.bitcoinCashBalance, currentUser.ethereumClassicBalance)")
        var postiveVal = 0, negativeVal = 0
        let count = coins.count
        let label = accountDescription
        if (count == 0) { //: Perhaps no connection?
            return
        }
        for coin in coins {
            if coin.difference() < 0 {
                negativeVal += 1
            } else {
                postiveVal += 1
            }
        }
        label.text! += "The crypto market is "
        if (negativeVal > postiveVal) {
            label.text! += "down today."
        } else if (negativeVal < postiveVal) {
            label.text! += "up today."
        } else { //: negativeVal == postiveVal
            label.text! += "up to something today."
        }
    }
    
    
    @objc func searchTapped() {
        self.navigationController?.pushViewController(DiscoverViewController(), animated: false)
    }
    @objc func moreTapped() {
        let portfolioController = PortfolioController()
        portfolioController.totalPortfolioValue.setTitle(self.accountBalanceLabel.text, for: .normal)
        portfolioController.coins = self.coins
        self.navigationController?.pushViewController(portfolioController, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        self.automaticallyAdjustsScrollViewInsets = false //: Without this there is an extra top padding for the collectionView
        
        socketClient.delegate = self
        socketClient.webSocket = ExampleWebSocketClient(url: URL(string: GDAXSocketClient.baseAPIURLString)!)
        socketClient.logger = GDAXSocketClientDefaultLogger()
        
        priceFormatter.numberStyle = .decimal
        priceFormatter.maximumFractionDigits = 2
        priceFormatter.minimumFractionDigits = 2
        
        timeFormatter.dateStyle = .short
        timeFormatter.timeStyle = .medium
        
        // view.backgroundColor = UIColor(red:0.35, green:0.54, blue:0.90, alpha:1.0) //: MARK: Use this blue color someplace else
        view.backgroundColor = UIColor(red:1.00, green:0.60, blue:0.00, alpha:1.0)
        self.view.addSubview(collectionView)
        self.view.addSubview(todaysDateLabel)
        self.view.addSubview(accountBalanceLabel)
        self.view.addSubview(accountDescription)
        
        collectionView.anchor(top: nil, bottom: self.view.bottomAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingBottom: -55, paddingLeft: 0, paddingRight: 0, width: 0, height: (self.view.frame.height / 2))
        
        let width = self.view.frame.width
        let cellWidth = (self.view.frame.width - 65)
        let diff = (width-cellWidth) / 2
        
        todaysDateLabel.anchor(top: nil, bottom: collectionView.topAnchor, left: collectionView.leftAnchor, right: collectionView.rightAnchor, paddingTop: 0, paddingBottom: -7, paddingLeft: diff, paddingRight: 0, width: 0, height: 25)
        
        if #available(iOS 11, *) {
            accountBalanceLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true

        } else {
            accountBalanceLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 5).isActive = true
        }
        accountBalanceLabel.anchor(top: nil, bottom: nil, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 55)
        accountDescription.anchor(top: accountBalanceLabel.bottomAnchor, bottom: todaysDateLabel.topAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: 5, paddingBottom: -10, paddingLeft: diff, paddingRight: diff, width: 0, height: 0)
        
        updateTimer()
    }
    
    func setupNav() {
        //: Changing nav bar to be clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        //: Adding Title with color
        self.navigationItem.title = "Slash"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Avenir-Heavy", size: 20)!, NSAttributedStringKey.foregroundColor: UIColor.white]
        
        //: Changing default back button
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
        //: Changes the bar button icons to white
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Search"), style: .plain, target: self, action: #selector(searchTapped))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "More Icon"), style: .plain, target: self, action: #selector(moreTapped))
        
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
                    //: One of the reasons we are here is because we are making too much requests at a time
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
    
    func updateTimer() {
        if timer != nil {
            if timer.isValid == true {
                timer.invalidate()
            }
        }
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(5), target: self, selector: #selector(self.updateCells), userInfo: nil, repeats: true)
        }
        
    }
    
    @objc func updateCells() {
        print("updateCells")
        self.collectionView.reloadData()
    }
    
    
    func updateInterval(_ interval: TimeInterval) {
        updateTimer()
    }
    
    func animateBackgroundColor(color: UIColor) {
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut], animations: {
            self.view.backgroundColor = color
        }, completion: nil)
    }
    
    //: MARK: viewWillAppear & viewDidDisappear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !socketClient.isConnected {
            socketClient.connect()
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
    }
}

//: MARK: CollectionView
extension HomeViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("numberOfItemsInSection called")
        return self.coins.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewController.coinCellId, for: indexPath) as! CoinCell
        if !coins.isEmpty{
            cell.update(coins[indexPath.item])
            //: MAKE SURE TO DO THIS, or else charts will not display!
            //let result = self.values.reversed() as [ChartDataEntry]
            let result = coins[indexPath.item].chartDataEntry.reversed() as [ChartDataEntry]
            //cell.chartView.backgroundColor = colors[indexPath.item]
            cell.setChartData(values: result, lineColor: colors[indexPath.item])
            cell.coinImageView.tintColor = colors[indexPath.item]
            cell.progressView.progressTintColor = colors[indexPath.item] // FIXME: Do I really want this?
            //: While the user is waiting for the chart, begin an animation
            if cell.chartView.isEmpty() {
                cell.startAnimating()
            } else {
                cell.stopAnimation()
            }
            print("Chart data: For \(coins[indexPath.item].officialName()), HIGH: \(String(describing: cell.chartView.data?.getYMax())) LOW: \(String(describing: cell.chartView.data?.getYMin()))")
            let percentage = currentUser.portfolioPercentage(coinName: coins[indexPath.item].officialName())
            print("For \(indexPath.item) the percentage is \(percentage)")
            cell.setupProgressBarAnimation(value: percentage)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.width - 65), height: (self.view.frame.height / 2))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //: Adjust the cell position
        let width = self.view.frame.width
        let cellWidth = (self.view.frame.width - 65)
        let diff = (width-cellWidth) / 2
        return UIEdgeInsets(top: 0, left: diff, bottom: 0, right: diff)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("The following was tapped: \(indexPath.item)")
        
        let currentCell = collectionView.cellForItem(at: indexPath) as! CoinCell
        if currentCell.isAnimating { currentCell.startAnimating() } //: FIXME: Find a better way to solve this issue
        
        let coinDetail = coins[indexPath.item]
        let coinControl = CoinController()
        let result = coinDetail.chartDataEntry.reversed() as [ChartDataEntry]
        coinControl.coin = coinDetail
        coinControl.dayResult = result
        coinControl.chartView.setData(values: result)
        
        self.navigationController?.pushViewController(coinControl, animated: true)
    }
    
    //: Check if collectionView cell takes up the screen
    //: https://stackoverflow.com/questions/46829901/how-to-determine-when-a-custom-uicollectionviewcell-is-100-on-the-screen
    func fullyVisibleCells(_ collectionView: UICollectionView) -> [IndexPath] {
        var returnCells = [IndexPath]()
        var visibleCells = collectionView.visibleCells
        visibleCells = visibleCells.filter({ cell -> Bool in
            let cellRect = collectionView.convert(cell.frame, to: collectionView.superview)
            return collectionView.frame.contains(cellRect)
        })
        //: Distint from for-in loop
        visibleCells.forEach({
            if let indexPath = collectionView.indexPath(for: $0) { returnCells.append(indexPath) }
        })
        return returnCells
    }
}


//: MARK: UIScrollView
extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleCells = fullyVisibleCells(self.collectionView)
        for cellArray in visibleCells {
            switch cellArray[1] {
            case 0:
                self.animateBackgroundColor(color: colors[0])
            case 1:
                self.animateBackgroundColor(color: colors[1])
            case 2:
                self.animateBackgroundColor(color: colors[2])
            case 3:
                self.animateBackgroundColor(color: colors[3])
            case 4:
                self.animateBackgroundColor(color: colors[4])
            default:
                return
            }
        }
    }
    
    //: https://gist.github.com/benjaminsnorris/a19cb14082b28027d183/revisions
    func snapToCenter() {
        let centerPoint = self.view.convert(self.view.center, to: collectionView)
        guard let centerIndexPath = collectionView.indexPathForItem(at: centerPoint) else {return}
        //: FIXME: There is an issue when user scrolls the first or last cell repeatedly
        collectionView.scrollToItem(at: centerIndexPath, at: .centeredHorizontally, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        snapToCenter()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (!decelerate) {
            snapToCenter()
        }
    }
}

//: MARK: GDAXSocketClientDelegate
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
                item.open = String(ticker.open24h)
                item.high = String(ticker.high24h)
                item.low = String(ticker.low24h)
                item.volume = String(ticker.volume24h)
                item.thirtyDayVolume = String(ticker.volume30d)
                
                //: Necessary to convert 6,500 to a double value.
                guard let price = item.currentPrice else {return}
                let splitPrice = price.split(separator: ",").joined(separator: "")
                guard let validPrice = Double(splitPrice) else {return}
                //: Lets store the price
                switch item.officialName() {
                case "Bitcoin":
                    UserDefaults.standard.setBTCPrice(value: validPrice)
                case "Ethereum":
                    UserDefaults.standard.setETHPrice(value: validPrice)
                case "Litecoin":
                    UserDefaults.standard.setLTCPrice(value: validPrice)
                case "Bitcoin Cash":
                    UserDefaults.standard.setBCHPrice(value: validPrice)
                case "Ethereum Classic":
                    UserDefaults.standard.setETCPrice(value: validPrice)
                default:
                    return
                }
                
                //: TODO: Do I want to update the account balance all the time or should the user decide when to update?
                let formattedPrice = priceFormatter.string(from: currentUser.balance() as NSNumber) ?? "0.00"
                self.accountBalanceLabel.text = "$" + formattedPrice //: FIXME: This shouldn't only be for US Dollar
            }
        }
        
        //        print("Currently i have: \(coins.count) items. The items are:")
        //        for item in coins {
        //            print(item.id)
        //        }
    }
}
