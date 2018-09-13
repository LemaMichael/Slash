//
//  DiscoverViewController.swift
//  Slash
//
//  Created by Michael Lema on 8/30/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import Foundation
import UIKit
import CryptoCompKit

class CryptoCoin: NSObject {
    var data: CoinData
    init(data: CoinData) {
        self.data = data
    }
}

class DiscoverViewController: UIViewController, TableVCDelegate {
    
    //: This gets called When TableViewController pops from the stack
    func didFinishTableVC(controller: CoinTableViewController, coin: CryptoCoin) {
        self.setData(coinID: coin.data.symbol)
        self.getPriceList(coinID: coin.data.symbol)
    }
    
    let cryptoCompKit = CryptoCompKit()
    var allCoins = [CryptoCoin]()
    var baseURL = String()
    var randomStr = String()
    let dispatchGroup = DispatchGroup()

    func setBackgroundImage() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = #imageLiteral(resourceName: "Fire")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        backgroundImage.alpha = 0.7
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    let searchBarView = SearchBarView()
    let coinContainerView = CoinContainerView()
    let descriptionView = DescriptionView()
    let detailContainerView = DetailContainerView()
    let detailOrAddView = DetailOrAddView()
    let detailsView: DetailsView = {
        let dv = DetailsView()
        dv.alpha = 0
        return dv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = UIColor.rgb(red: 199, green: 190, blue: 177)
        view.backgroundColor = UIColor.rgb(red: 24, green: 50, blue: 50)
        setBackgroundImage()
        searchBarView.searchButton.isEnabled = false
        detailOrAddView.detailButton.addTarget(self, action: #selector(displayDetailsView), for: .touchUpInside)
        searchBarView.searchButton.addTarget(self, action: #selector(displayTable), for: .touchUpInside)
        self.view.addSubview(searchBarView)
        self.view.addSubview(coinContainerView)
        self.view.addSubview(descriptionView)
        self.view.addSubview(detailContainerView)
        self.view.addSubview(detailOrAddView)
        self.view.addSubview(detailsView)
        setupConstraints()
        
        let defaultCoins = ["BTC", "ETH", "LTC", "BCH", "ETC", "XMR", "NANO"]
        let randomIndex = Int(arc4random_uniform(UInt32(defaultCoins.count)))
        randomStr = defaultCoins[randomIndex]
        getPriceList(coinID: randomStr)
        getCoinList()
    }
    
    @objc func displayDetailsView() {
        detailOrAddView.detailButton.isSelected = !detailOrAddView.detailButton.isSelected
        detailsView.alpha = detailOrAddView.detailButton.isSelected ? 1 : 0
    }
    
    @objc func displayTable() {
        let coinTableController = CoinTableViewController()
        coinTableController.delegate = self
        coinTableController.coins = allCoins.sorted(by: { Int($0.data.sortOrder) ?? 0 < Int($1.data.sortOrder) ?? 0 })
        self.navigationController?.pushViewController(coinTableController, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

extension DiscoverViewController {
    func setupConstraints() {
        var bottomAnchor = NSLayoutYAxisAnchor()
        if #available(iOS 11, *) {
            searchBarView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
            bottomAnchor = self.view.safeAreaLayoutGuide.bottomAnchor
        } else {
            searchBarView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 5).isActive = true
            bottomAnchor = self.view.bottomAnchor
        }
        searchBarView.anchor(top: nil, bottom: nil, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 18, paddingRight: 18, width: 0, height: 45)
        let customHeight = ((self.view.bounds.height / 2) - 45 - 5) * 0.3
        descriptionView.anchor(top: nil, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: customHeight)
        descriptionView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 1).isActive = true 
        
        let containerHeight = customHeight * 0.6
        coinContainerView.anchor(top: nil, bottom: descriptionView.topAnchor, left: nil, right: searchBarView.rightAnchor, paddingTop: 0, paddingBottom: -10, paddingLeft: 0, paddingRight: 0, width: (view.bounds.width / 2) * 0.715, height: containerHeight)
        
        detailContainerView.anchor(top: descriptionView.bottomAnchor, bottom: bottomAnchor, left: view.leftAnchor, right: nil, paddingTop: 40, paddingBottom: -18, paddingLeft: 18, paddingRight: 0, width: (view.bounds.width/2) * 0.9, height: 0)
        
        detailOrAddView.anchor(top: nil, bottom: detailContainerView.bottomAnchor, left: nil, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 18, width: (view.bounds.width/2) * 0.72, height: 25)
        
        detailsView.anchor(top: searchBarView.bottomAnchor, bottom: nil, left: self.view.leftAnchor, right: nil, paddingTop: 6, paddingBottom: 0, paddingLeft: 18, paddingRight: 0, width: (view.bounds.width / 2) * 0.8, height: containerHeight * 1.65)
        
    }
}

//: MARK - Data from CryptoCompare
extension DiscoverViewController {
    
    func getCoinList() {
        cryptoCompKit.coinList { list, result in
            switch result {
            case .success:
                self.baseURL = list.baseLinkURL
                self.dispatchGroup.enter()
                for coin in list.coins {
                    let cryptoCoin = CryptoCoin(data: coin.value)
                    self.allCoins.append(cryptoCoin)
                }
                self.dispatchGroup.leave()
                self.dispatchGroup.notify(queue: DispatchQueue.main, execute: {
                    self.searchBarView.searchButton.isEnabled = true
                    self.setData(coinID: self.randomStr)
                })
                
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    
    func setData(coinID: String ) {
        guard let coin = self.allCoins.first(where: { $0.data.symbol == coinID }) else {return}
        self.getSnapshot(id: coin.data.id)
        if let validURL = coin.data.imageURL {
            self.detailContainerView.imageView.downloaded(from: self.baseURL + validURL)
        }
        DispatchQueue.main.async {
            self.coinContainerView.symbolLabel.text = coin.data.symbol
            self.coinContainerView.nameLabel.text = coin.data.coinName
        }
    }
    
    func getPriceList(coinID: String) {
        let to = ["USD"] //: We can change this to many differency currencies.
        cryptoCompKit.priceList(fSyms: [coinID], tSyms: to) { list, result in
            switch result {
            case .success:
                guard let coinDict = list.prices[coinID] else { return }
             
                for (_, coinData) in coinDict {
                    let coin = coinData
                    //print("!! \(coin.change24Hour, coin.changeDay, coin.marketCap, coin.fromSymbol, coin.flags, coin.totalVolume24Hour)")
                    DispatchQueue.main.async {
                        let detailView = self.detailContainerView
                        let formatter = CurrencyFormatter.sharedInstance
                        let options = CurrencyFormatterOptions()
                        options.showPositivePrefix = true
                        options.showNegativePrefix = true
                        
                        let coinOption = CurrencyFormatterOptions()
                        coinOption.allowTruncation = true
                        
                        detailView.priceLabel.text = formatter.formatAmount(coin.price, currency: "USD", options: nil)
                        detailView.marketCapLabel.text = "Market Cap: " + formatter.formatAmount(coin.marketCap, currency: "USD", options: nil)
                        detailView.volume24hLabel.text = "Volume (24h): " + formatter.formatAmount(coin.totalVolume24Hour, currency: "USD", options: nil)
                        detailView.circulatingSupplyLabel.text = "Circulating Supply: " + formatter.formatCoin(coin.supply, currency: "", options: nil) +  " \(coin.fromSymbol)"
                        detailView.change24hLabel.text = "Change (24h): " + formatter.formatAmount(coin.change24Hour, currency: "USD", options: options)
                        detailView.high24hLabel.text = "High (24h): " + formatter.formatAmount(coin.high24Hour, currency: "USD", options: nil)
                        detailView.low24hLabel.text = "Low (24h): " + formatter.formatAmount(coin.low24Hour, currency: "USD", options: nil)
                    }
                }
            case .failure:
                print("Fail")
            }
        }
    }
    
    func getSnapshot(id: String) {
        guard let url = URL(string: "https://www.cryptocompare.com/api/data/coinsnapshotfullbyid/?id=\(id)") else {
            self.descriptionView.textView.attributedText = NSAttributedString(string: "")
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let decoder = JSONDecoder()
                let snapshot = try decoder.decode(Stats.self, from: data)
                
               // print("!!! \(snapshot.data.general.startDate, snapshot.data.general.totalCoinSupply, snapshot.data.general.totalCoinsMined, snapshot.data.general.algorithm, snapshot.data.general.proofType)")
                DispatchQueue.main.async {
                    self.modifyViews(general: snapshot.data.general)
                }
            } catch let error as NSError {
                print(error)
                DispatchQueue.main.async {
                    self.descriptionView.textView.attributedText = NSAttributedString(string: "")
                    self.detailsView.startDateLabel.text = "Start Date: "
                    self.detailsView.totalSupplyLabel.text = "Total Supply: "
                    self.detailsView.algorithmLabel.text = "Algorithm: "
                    self.detailsView.proofLabel.text = "Proof Type: "
                }
            }
            }.resume()
    }
    
    fileprivate func modifyViews(general: General) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 1.5
        let attributes = [NSAttributedString.Key.paragraphStyle: style, NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 11.4)!, NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 140, green: 135, blue: 137)]
        self.descriptionView.textView.attributedText = NSAttributedString(string: general.description.htmlToString, attributes: attributes)
        
        //: For DetailView
        let startDate = general.startDate
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.date(from: startDate) ?? Date()
        dateFormatter.dateFormat = "MMM. dd, yyyy"
        let dateString = dateFormatter.string(from: date)
        
        self.detailsView.startDateLabel.text = "Start Date: " + dateString
        let supply = Double(general.totalCoinSupply)  ?? 0
        self.detailsView.totalSupplyLabel.text = (supply == 0) ? "Total Supply: Uncapped" : "Total Supply: " + CurrencyFormatter.sharedInstance.formatCoin(supply, currency: "", options: nil)
        
        self.detailsView.algorithmLabel.text = "Algorithm: " + general.algorithm
        self.detailsView.proofLabel.text = "Proof Type: " + general.proofType
    }
}
