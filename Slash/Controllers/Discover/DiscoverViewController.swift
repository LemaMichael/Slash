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

class DiscoverViewController: UIViewController {
    let cryptoCompKit = CryptoCompKit()
    
    func setBackgroundImage() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = #imageLiteral(resourceName: "Fire")
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        backgroundImage.alpha = 0.7
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    let searchBarView = SearchBarView()
    let coinContainerView = CoinContainerView()
    let descriptionView = DescriptionView()
    let detailContainerView = DetailContainerView()
    let detailOrAddView = DetailOrAddView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConnection()
        //view.backgroundColor = UIColor.rgb(red: 199, green: 190, blue: 177)
        view.backgroundColor = UIColor.rgb(red: 24, green: 50, blue: 50)
        setBackgroundImage()
        self.view.addSubview(searchBarView)
        self.view.addSubview(coinContainerView)
        self.view.addSubview(descriptionView)
        self.view.addSubview(detailContainerView)
        self.view.addSubview(detailOrAddView)
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        coinContainerView.anchor(top: nil, bottom: descriptionView.topAnchor, left: nil, right: searchBarView.rightAnchor, paddingTop: 0, paddingBottom: -10, paddingLeft: 0, paddingRight: 0, width: (view.bounds.width / 2) * 0.7, height: containerHeight)
        
        detailContainerView.anchor(top: descriptionView.bottomAnchor, bottom: bottomAnchor, left: view.leftAnchor, right: nil, paddingTop: 40, paddingBottom: -18, paddingLeft: 18, paddingRight: 0, width: (view.bounds.width/2) * 0.9, height: 0)
        
        detailOrAddView.anchor(top: nil, bottom: detailContainerView.bottomAnchor, left: nil, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 18, width: (view.bounds.width/2) * 0.72, height: 25)
        
    }
}

extension DiscoverViewController {
    func setupConnection() {
        let baseImageURL = "https://www.cryptocompare.com"
        cryptoCompKit.coinList { list, result in
            switch result {
            case .success(_):
                print("!! \(list.coins["BTC"]!.coinName, list.coins["BTC"]!.imageURL,list.coins["BTC"]!.url, list.coins["XMR"]!.id )")
                self.getSnapshot(id: list.coins["XMR"]!.id)
                self.detailContainerView.imageView.downloaded(from: baseImageURL + list.coins["XMR"]!.imageURL!)
                DispatchQueue.main.async {
                    self.coinContainerView.symbolLabel.text = list.coins["XMR"]!.symbol
                    self.coinContainerView.nameLabel.text = list.coins["XMR"]!.coinName
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
        
        let from = ["BTC","ETH","LTC", "XMR", "NANO"]
        let to = ["USD"]
        cryptoCompKit.priceList(fSyms:from, tSyms:to) { list, result in
            switch result {
            case .success(_):
                for item in list.prices["XMR"]! {
                    print("!! \(item.key), \(item.value)")
                    let coin = item.value
                    print("!! \(coin.change24Hour, coin.changeDay, coin.marketCap, coin.fromSymbol, coin.flags, coin.totalVolume24Hour)")
                    DispatchQueue.main.async {
                        let detailView = self.detailContainerView
                        let formatter = CurrencyFormatter.sharedInstance
                        let options = CurrencyFormatterOptions()
                        options.showPositivePrefix = true
                        options.showNegativePrefix = true
                        
                        let coinOption = CurrencyFormatterOptions()
                        coinOption.allowTruncation = true
                        
                        let marketCapText = detailView.marketCapLabel.text ?? ""
                        let volume24Text = detailView.volume24hLabel.text ?? ""
                        let supplyText = detailView.circulatingSupplyLabel.text ?? ""
                        let changeText = detailView.change24hLabel.text ?? ""
                        let highText = detailView.high24hLabel.text ?? ""
                        let lowText = detailView.low24hLabel.text  ?? ""
                        detailView.priceLabel.text = formatter.formatAmount(coin.price, currency: "USD", options: nil)
                        detailView.marketCapLabel.text = marketCapText + formatter.formatAmount(coin.marketCap, currency: "USD", options:nil)
                        detailView.volume24hLabel.text = volume24Text + formatter.formatAmount(coin.totalVolume24Hour, currency: "USD", options: nil)
                        detailView.circulatingSupplyLabel.text = supplyText + formatter.formatCoin(coin.supply, currency: "", options: nil) +  " \(coin.fromSymbol)"
                        detailView.change24hLabel.text = changeText + formatter.formatAmount(coin.change24Hour, currency: "USD", options: options)
                        detailView.high24hLabel.text = highText + formatter.formatAmount(coin.high24Hour, currency: "USD", options: nil)
                        detailView.low24hLabel.text = lowText + formatter.formatAmount(coin.low24Hour, currency: "USD", options: nil)
                    }
                }
            case .failure(_):
                print("Fail")
            }
        }
    }
    
    func getSnapshot(id: String) {
        guard let url = URL(string: "https://www.cryptocompare.com/api/data/coinsnapshotfullbyid/?id=\(id)") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            do {
                let decoder = JSONDecoder()
                let snapshot = try decoder.decode(Stats.self, from: data)
                let description = snapshot.data.general.description
                //print(description.htmlToString)
                DispatchQueue.main.async {
                    let style = NSMutableParagraphStyle()
                    style.lineSpacing = 1.5
                    let attributes = [NSAttributedStringKey.paragraphStyle: style, NSAttributedStringKey.font: UIFont(name: "Avenir-Heavy", size: 11.4)!, NSAttributedStringKey.foregroundColor: UIColor.rgb(red: 140, green: 135, blue: 137)]
                    self.descriptionView.textView.attributedText = NSAttributedString(string: description.htmlToString, attributes: attributes)
                }
            } catch let error as NSError {
                print(error)
            }
        }.resume()
    }
}
