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
        backgroundImage.alpha = 0.95
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    let searchBarView = SearchBarView()
    let coinContainerView = CoinContainerView()
    let placeHolderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
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
        self.view.addSubview(placeHolderView)
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
        placeHolderView.anchor(top: nil, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: customHeight)
        placeHolderView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 1).isActive = true 
        
        let containerHeight = customHeight * 0.6
        coinContainerView.anchor(top: nil, bottom: placeHolderView.topAnchor, left: nil, right: searchBarView.rightAnchor, paddingTop: 0, paddingBottom: -10, paddingLeft: 0, paddingRight: 0, width: (view.bounds.width / 2) * 0.7, height: containerHeight)
        
        detailContainerView.anchor(top: placeHolderView.bottomAnchor, bottom: bottomAnchor, left: view.leftAnchor, right: nil, paddingTop: 40, paddingBottom: -18, paddingLeft: 18, paddingRight: 0, width: (view.bounds.width/2) * 0.8, height: 0)
        
        detailOrAddView.anchor(top: nil, bottom: detailContainerView.bottomAnchor, left: nil, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 18, width: (view.bounds.width/2) * 0.72, height: 25)
        
    }
}

extension DiscoverViewController {
    func setupConnection() {
        cryptoCompKit.coinList { list, result in
            switch result {
            case .success(_):
                print("!! \(list.coins["BTC"]!.coinName)")
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
        
        let from = ["BTC","ETH","LTC"]
        let to = ["USD"]
        cryptoCompKit.priceList(fSyms:from, tSyms:to) { list, result in
            switch result {
            case .success(_):
                for item in list.prices["BTC"]! {
                    print("!! \(item.key), \(item.value)")
                    let data = item.value
                    print("!! \(data.change24Hour, data.changeDay, data.marketCap, data.fromSymbol, data.flags, data.totalVolume24Hour)")
                }
            case .failure(_):
                print("FAil")
            }
        }
    }
}
